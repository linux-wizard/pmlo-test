output "ssh_private_key" {
  description = "SSH private key"
  value       = tls_private_key.pmlo-ssh-keys-gen.private_key_pem
  sensitive   = true
}