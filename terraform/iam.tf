
data "aws_iam_policy_document" "ec2_assume_policy" {   
  statement { 
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cassandra_iam_policy" { 
    statement { 
        resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
        effect = "Allow"
        actions = [
            "s3:ListBucketVersions",
            "s3:ListBucket"
        ]
        condition { 
            test = "StringLike"
            variable = "s3:prefix"
            values = [ "cassandra/*" ]
        }
    }
    statement { 
        resources = ["arn:aws:s3:::${var.s3_bucket_name}/cassandra/*"]
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:AbortMultipartUpload",
            "s3:DeleteObject",
            "s3:ListMultipartUploadParts"
        ]
    }
    
}

resource "aws_iam_policy" "cassandra_node_policy" {
  name = "cassandra_node_policy"

  policy = data.aws_iam_policy_document.cassandra_iam_policy.json

}


resource "aws_iam_role" "cassandra_node_role" {
  name                = "cassandra_node_role"
  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_policy.json
  managed_policy_arns = [
    aws_iam_policy.cassandra_node_policy.arn
  ]
}

resource "aws_iam_instance_profile" "cassandra_node_profile" {
  name = "casandra_node_profile"
  role = aws_iam_role.cassandra_node_role.name
}
