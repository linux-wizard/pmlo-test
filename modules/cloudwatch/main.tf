resource "aws_cloudwatch_log_group" "pmlo-test-pgadmin4" {
  name = "pmlo-test-pgadmin4-prod"

  tags = {
    Environment = "production"
    Application = "PGAdmin4"
  }
}