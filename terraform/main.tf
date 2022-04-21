module "kubeone_cluster" {
  # See ./modules/kubeone-cluster/azure/variables.tf for all available variables
  source = "./modules/kubeone-cluster/azure"

  # KubeOne specific variables
  cluster_name        = "friendly-easley"
  ssh_public_key_file = "~/.ssh/k8s_rsa.pub"
  ssh_username        = "ubuntu"

  # Cloud provider specific variables
  location                           = "westeurope"
  worker_vm_size                     = "Standard_F2"
  initial_machinedeployment_replicas = 3
}
