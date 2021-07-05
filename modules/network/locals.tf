locals {
  my_public_ip = chomp(data.http.my_public_ip.body)
}