# K8s Cluster Creation (Highly Available)

This exercise to create an highly available kubernetes cluster using kubeadm tool.
HA guide that was followed: [Kubeadm HA](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/). Specifically the External etcd nodes steps.

## Considerations

### HA

From: [Kubeadm HA Topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/). Highly available cluster can be created in two ways:

1. Stacked Control plane nodes: Etcd nodes are co-located with control plane nodes
2. External etcd nodes: Etcd runs on separate nodes

Option 2 was selected because the redundancy is compromised when a control plane node or etcd node goes down. The downside is more infrastructure but it is a good tradeoff.

## Caveats

1. My user isn't allowed to create a load balancer so a single master node (with etcd) + multiple workers is the configuration chosen
2. I can't launch an instance in Availability zone: ap-south-1c so 1 master in ap-south-1a and 2 workers in ap-south-1a & ap-south-1b was chosen

## Work Done

Guide followed: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

### Infra Created

1. Created VPC with public and private subnets
2. Created 1 master node
3. Created 2 worker nodes
4. Opened all ports between master and workers

### On all nodes

1. Installed containerd as CRI runtime while using Cgroup drivers:
   1. https://kubernetes.io/docs/setup/production-environment/container-runtimes/
   2. https://github.com/containerd/containerd/blob/master/docs/cri/installation.md
2. Installed kubeadm, kubelet, kubectl

### On master node

1. Executed kubeadm init on master node with config file:

   ```yaml
   kind: ClusterConfiguration
   apiVersion: kubeadm.k8s.io/v1beta2
   kubernetesVersion: v1.21.0
   apiServer:
     extraArgs:
       advertise-address: 0.0.0.0
     certSANs:
     - <privateIpMaster>
     - <publicIpMaster>
   networking:
     podSubnet: "10.0.0.0/24" # match what was created by VPC
   ---
   kind: KubeletConfiguration
   apiVersion: kubelet.config.k8s.io/v1beta1
   cgroupDriver: systemd
   ```

   ExtraArgs and CertSans were added to allow for remote kubernetes access

2. Used kubeconfig generated to install Flannel network plugin. Flannel was chosen as it is simple and easy to setup. Guide: https://github.com/flannel-io/flannel

### On worker node

1. Executed kubeadm join command with podCidr specified

### Misc

1. Untainted master node to allow pods to be scheduled


## Future Work

### Automation

Given the time limit, work here was executed manually following the guide listed above.  
Future work would be to automate it using:

1. Terraform for basic infrastructure -> VPC, NLB, ASG (control plane, worker, etcd nodes)
2. Store configuration files in AWS Secrets Manager (SSM)
3. Packer to build base images with userdata script to auto-join the k8s cluster by retrieving config files from AWS SSM
