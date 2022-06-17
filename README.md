# My Kube Labs

A kubernetes labs that uses [kubespray](https://github.com/kubernetes-sigs/kubespray) to boostrap the cluster.

## Labs

* [Running diagnostics on a k8s cluser](./notebooks/diagnostics.ipynb)
* [Installing prometheus + grafana](./notebooks/prometheus.ipynb)
* [Playing with Ingress](./notebooks/ingress.ipynb)
* [Installing gitlab-ce using the official helm chart](./notebooks/gitlab.ipynb)

# If you want to run the labs yourself

## Requirements

* A container manager (docker, containerd, ...)
* A [Hetzner Cloud](https://console.hetzner.cloud/) account and a  *HCLOUD_TOKEN*

## Run

```shell
# Build the image
$ bin/container/build.sh
# Run the container
$ HCLOUD_TOKEN=<YOUR_HCLOUD_TOKEN> bin/container/start.sh
# Provision the remote servers
# This takes 10-20 minutes
$ docker exec kube-lab bin/cluster/provision.sh
```

## Stop

```shell
$ bin/container/stop.sh
```

## Project structure

```shell
├── Dockerfile
├── README.md
├── bin
│   ├── cluster
│   │   ├── ...
│   ├── container
│   │   ├── build.sh
│   │   ├── entrypoint.sh
│   │   ├── start.sh
│   │   └── stop.sh
│   └── git_hooks
│       └── pre_commit.sh
├── manifests
│   └── grafana.yml
├── mycluster
│   ├── group_vars
│   │   ├── all
│   │   │   ├── all.yml
│   │   │   ├── aws.yml
│   │   │   ├── ...
│   │   ├── etcd.yml
│   │   └── k8s_cluster
│   │       ├── addons.yml
│   │       ├── k8s-cluster.yml
│   │       ├── ...
│   └── hosts.yml
├── notebooks
│   ├── apps.ipynb
│   ├── ...
├── playbooks
│   ├── create.yml
│   ├── ...
└── requirements.txt
```
