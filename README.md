# K8s Cluster Creation (Highly Available)

This exercise to create an highly available kubernetes cluster using kubeadm tool.
HA guide that was followed: [Kubeadm HA](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/). Specifically the External etcd nodes steps.

## Considerations

### HA

From: [Kubeadm HA Topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/). Highly available cluster can be created in two ways:

1. Stacked Control plane nodes: Etcd nodes are co-located with control plane nodes
2. External etcd nodes: Etcd runs on separate nodes

Option 2 was selected because the redundancy is compromised when a control plane node or etcd node goes down. The downside is more infrastructure but it is a good tradeoff.

## Work Done

1. Created 3 node ETCD cluster
2. Created 3 node Control Plane cluster
3. Created 3 worker nodes
4. Created a Network Load Balancer (NLB) to 

## Future Work

### Automation

Given the time limit, work here was executed manually following the guide listed above.  
Future work would be to automate it using:

1. Terraform for basic infrastructure -> VPC, LB, ASG (control plane, worker, etcd nodes)
2. Store configuration files in AWS Secrets Manager (SSM)
3. Packer to build base images with userdata script to auto-join the k8s cluster by retrieving config files from AWS SSM
