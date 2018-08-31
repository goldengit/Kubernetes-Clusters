# Kubernetes-Cluster automated build instructions:

Kubernetes scripts, automation, code for setting up clusters etc...




Run the kube-stack.sh script to automate the preparation of nodes/master and configure/deploy a full working Kubernetes cluster.


Assumed environment:

You need at least one physical or virtual machine that meets the Kubernetes kubeadm requirements:



* Before you begin

    One or more machines running one of:
        Ubuntu 16.04+
        Debian 9
        CentOS 7
        RHEL 7
        Fedora 25/26 (best-effort)
        HypriotOS v1.0.1+
        Container Linux (tested with 1800.6.0)
    2 GB or more of RAM per machine (any less will leave little room for your apps)
    2 CPUs or more
    Full network connectivity between all machines in the cluster (public or private network is fine)
    Unique hostname, MAC address, and product_uuid for every node. See here for more details.
    Certain ports are open on your machines. See here for more details.
    Swap disabled. You MUST disable swap in order for the kubelet to work properly.

Verify the MAC address and product_uuid are unique for every node

    You can get the MAC address of the network interfaces using the command ip link or ifconfig -a
    The product_uuid can be checked by using the command sudo cat /sys/class/dmi/id/product_uuid

It is very likely that hardware devices will have unique addresses, although some virtual machines may have identical values. Kubernetes uses these values to uniquely identify the nodes in the cluster. If these values are not unique to each node, the installation process may fail.
Check network adapters

If you have more than one network adapter, and your Kubernetes components are not reachable on the default route, we recommend you add IP route(s) so Kubernetes cluster addresses go via the appropriate adapter.
Check required ports
Master node(s)
Protocol 	Direction 	Port Range 	Purpose 	Used By
TCP 	Inbound 	6443* 	Kubernetes API server 	All
TCP 	Inbound 	2379-2380 	etcd server client API 	kube-apiserver, etcd
TCP 	Inbound 	10250 	Kubelet API 	Self, Control plane
TCP 	Inbound 	10251 	kube-scheduler 	Self
TCP 	Inbound 	10252 	kube-controller-manager 	Self
Worker node(s)
Protocol 	Direction 	Port Range 	Purpose 	Used By
TCP 	Inbound 	10250 	Kubelet API 	Self, Control plane
TCP 	Inbound 	30000-32767 	NodePort Services** 	All



* Update your hosts fully

$ sudo apt-get update && sudo apt-get upgrade



* Then proceed with cloning this repo to all your nodes(including that which serve as your master) or copy the kube-stack.sh script to each machine and run from there ( ./kube-stack.sh )

* You may need to run the script as root for option 3 (Install Kubeadm toolbox)

* Run through the script options and complete steps 1-3 on all hosts. Step 6 is to be run on the Master node only. It will output instructions for joining your nodes to it at the end.


