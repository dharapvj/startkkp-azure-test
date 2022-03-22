cluster_name                       = "condescending-kalam"
location                           = "westeurope"
ssh_public_key_file                = "~/.ssh/k8s_rsa.pub"
ssh_username                       = "ubuntu"
worker_os                          = "ubuntu"
worker_vm_size                     = "Standard_F2"
initial_machinedeployment_replicas = 3
control_plane_vm_size              = "Standard_F2"
control_plane_vm_count             = 3
# More variables can be overridden here, see variables.tf.
