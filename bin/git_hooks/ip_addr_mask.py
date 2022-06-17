import ipaddress
import os
import subprocess
import sys
from dataclasses import dataclass

REPLACE_WITH = 'x'

SCRIPT_NAME = sys.argv[0].split('/')[-1]

HELP = f"""
Find public IP addresses that you don't want in the repo and interactively mask parts of it.
For example, 10.10.1.1 becomes '{REPLACE_WITH * 3}.{REPLACE_WITH * 3}.1.1'.

Some well known public and example IP addresses are whitelisted and won't be masked.

This script is best used as a git pre-commit hook.

Usage:

python3 {SCRIPT_NAME} [--mask]

Parameters:

    --mask      Interactively mask parts of the IP addresses with '{REPLACE_WITH}'

"""

IGNORE_IPS = [
    '1.2.3.0',  # example IP address
    '1.2.3.4',  # example IP address
    '1.1.1.1',  # cloudflare DNS
    '2.2.2.2',  # example IP address
    '8.8.8.8',  # google DNS
    '8.8.4.4',  # example IP address
    '100.64.0.0',  # example IP address
]

IP_REGEX = '([0-9]{1,3}[\.]){3}[0-9]{1,3}'


@dataclass
class Hit:
    file: str
    line: str
    ip: str


def get_ips() -> [str]:
    raw_ips = subprocess.run(['git', '--no-pager', 'grep', '-rEoh', IP_REGEX], capture_output=True)
    ips = []
    for ip in set(raw_ips.stdout.decode("utf-8").split("\n")):
        if not ip:
            continue
        if ip in IGNORE_IPS:
            continue
        if not ipaddress.ip_address(ip).is_private:
            ips.append(ip)
    return ips


def get_files() -> [str]:
    files = subprocess.run(['git', '--no-pager', 'grep', '--name-only', '-rE', IP_REGEX],
                           capture_output=True)
    files = files.stdout.decode("utf-8").split("\n")
    return [f for f in files if f]


def check(ips: [str], files: [str]) -> [Hit]:
    _hits = []
    for file in files:
        with open(os.path.abspath(file), 'r') as f:
            for line in f.readlines():
                for ip in ips:
                    if ip in line:
                        _hits.append(Hit(file=file, line=line, ip=ip))
    return _hits


def mask(before: str) -> str:
    parts = before.split('.')
    return f"{REPLACE_WITH * 3}.{REPLACE_WITH * 3}.{parts[2]}.{parts[3]}"


def replace(_hits: [Hit]) -> None:
    for hit in _hits:
        print(f'\nFile: {os.path.abspath(hit.file)}')
        print(f'Replace "{hit.ip}" with "{mask(hit.ip)}"\n')
        confirm = input(f'(y)es / (n)o / (q)uit\n')
        if confirm.lower() not in ['y', 'n']:
            exit(0)
        if confirm.lower() == "n":
            continue
        with open(os.path.abspath(hit.file), 'r') as f:
            content = f.read()
            content = content.replace(hit.ip, mask(hit.ip), 1)
        with open(os.path.abspath(hit.file), 'w') as f:
            f.write(content)


def main():
    if "--help" in sys.argv:
        print(HELP)
        exit(0)

    print("Running IP address check...\n")
    print(f"ℹ Ignoring {IGNORE_IPS}\n")
    hits = check(get_ips(), get_files())

    if len(hits) == 0:
        print("✅ No unwanted IP addresses found. Go ahead and commit ...")
        exit(0)

    if len(sys.argv) == 2 and sys.argv[1] == '--mask':
        replace(hits)
        exit(0)

    if len(hits) > 0:
        print(f"❌ Can't commit. Unwanted IP addresses found. Run {SCRIPT_NAME} --mask")
        exit(1)


main()
