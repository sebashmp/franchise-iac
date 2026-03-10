resource "aws_dynamodb_table" "franchises" {
  name         = "${var.project}-${var.environment}-franchises"
  billing_mode = var.billing_mode
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-franchises"
  })
}

resource "aws_dynamodb_table" "branches" {
  name         = "${var.project}-${var.environment}-branches"
  billing_mode = var.billing_mode
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "franchiseId"
    type = "S"
  }

  global_secondary_index {
    name            = "franchiseId-index"
    hash_key        = "franchiseId"
    projection_type = "ALL"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-branches"
  })
}

resource "aws_dynamodb_table" "products" {
  name         = "${var.project}-${var.environment}-products"
  billing_mode = var.billing_mode
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "branchId"
    type = "S"
  }

  global_secondary_index {
    name            = "branchId-index"
    hash_key        = "branchId"
    projection_type = "ALL"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-products"
  })
}
