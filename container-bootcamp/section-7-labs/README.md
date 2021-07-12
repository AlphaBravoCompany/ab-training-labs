Create a K3d cluster: k3d cluster create lab-cluster --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer

Switch context to the cluster: kubectl config use-context k3d-lab-cluster

Get cluster info: kubectl cluster-info

export cluster config: k3d kubeconfig get lab-cluster > /ab/lab-cluster-config.yml

Delete K3d cluster: k3d cluster delete lab-cluster