resource "aws_dynamodb_table" "remote_infra_lock_table" {
  name         = "remote_infra_lock_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name = "remote_infra_lock_table"
  }
}
