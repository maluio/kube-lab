# Kube Lab

A kubernetes lab environment that 

* mixes [kubespray](https://github.com/kubernetes-sigs/kubespray) with custom ansible playbooks to boostrap kubernetes clusters in different configurations
* uses [Jupyter Notebooks](https://jupyter.org/) to run commands in those clusters and stores the outputs for reproducibility and documentation

**Please note: The kubernetes clusters created by this project are for educational purposes only.**

## Labs / Notebooks

Running commands in Jupyter Notebooks makes it easy to fiddle with the cluster while saving the output. GitHub and Gitlab render the notebooks in the browser which is a very convient way to document what you have been doing.

Here are some of the notebooks I have been working on (most of which are still work in progress):

* [Running diagnostics in a k8s cluster](./notebooks/diagnostics.ipynb)
* [Prometheus Operator + kube-prometheus](./notebooks/prometheus)
* [Playing with Ingress](./notebooks/ingress.ipynb)
* [Installing gitlab-ce using the official helm chart](./notebooks/gitlab.ipynb)

# Development / Create your own labs

Running the project locally spins up Jupyter Labs in a container.

## Requirements

* A container runtime (docker, containerd, ...)
* A [Hetzner Cloud](https://console.hetzner.cloud/) account and a *HCLOUD_TOKEN*

## Run

```shell
# Build the image
$ bin/container/build.sh
# Run the container
$ HCLOUD_TOKEN=<YOUR_HCLOUD_TOKEN> bin/container/start.sh
```

Please check standard output. You'll find the url to open Jupyter Labs locally in you browser.

```shell
# Provisioning the remote servers
# This takes 10-20 minutes
$ docker exec kube-lab bin/cluster/provision.sh
```

You can now use Jupyter Labs to run your experiments in the cluster.

## Stop

```shell
# Attention: This script not only stops the container but also deletes the whole cluster!
$ bin/container/stop.sh
```

## Project structure

* On building the image the [kubespray repo](https://github.com/kubernetes-sigs/kubespray) is checked out in the image in a path outside the project root.
* The `inventory/mycluster` directory is a copy of kubespray's`inventory/sample` directory. Everything in there concerns the ansible config for kubespray. 
* Modifications to the configuration happen either in `inventory/mycluster` or by providing `-e PARAMETER=value` to the `ansible-playbook` command.

```shell
├── Dockerfile
├── bin   # project specific scripts
│   ├── cluster
│   │   ├── ...
│   ├── container
│   │   ├── build.sh
│   │   ├── entrypoint.sh
│   │   ├── start.sh
│   │   └── stop.sh
│   └── git_hooks
│       └── pre_commit.sh
├── manifests # manifests used as part of the labs
│   └── ...
├── mycluster # cluster configuration for kubespray based on its sample configuration
│   ├── group_vars
│   │   ├── ...
│   └── hosts.yml
├── notebooks # notebooks / labs 
│   ├── apps.ipynb
│   ├── ...
├── playbooks # custom playbooks specific to this project
│   ├── create.yml
│   ├── ...
└── requirements.txt # python dependencies that are added to the dependencies requried by kubespray
```
