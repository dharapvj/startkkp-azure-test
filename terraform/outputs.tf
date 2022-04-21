output "kubeone_api" {
  description = "Hostname or IP Address of the load balancer used as Kubernetes API endpoint"
  value       = module.kubeone_cluster.kubeone_api
}

output "kubeone_hosts" {
  description = "Control plane endpoints to SSH to"
  value       = module.kubeone_cluster.kubeone_hosts
}

output "kubeone_workers" {
  description = "Workers definitions, that will be transformed into MachineDeployment object"
  value       = module.kubeone_cluster.kubeone_workers
}
