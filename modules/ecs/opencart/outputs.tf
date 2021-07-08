output "aws_lb_app_dns" {
  description = "DNS name for App LB"
  value       = aws_lb.pmlo-test-app.dns_name
}

// output "ecr_repository_worker_endpoint" {
//     value = aws_ecr_repository.worker.repository_url
// }