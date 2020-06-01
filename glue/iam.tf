
# resource "aws_iam_policy" "policy" {
#   name        = "${local.product}-${local.service}-${local.environment}-policy"
#   description = "Glue Policy"
#   policy      = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "glue:*",
#                 "s3:GetBucketLocation",
#                 "s3:ListBucket",
#                 "s3:ListAllMyBuckets",
#                 "s3:GetBucketAcl",
#                 "ec2:DescribeVpcEndpoints",
#                 "ec2:DescribeRouteTables",
#                 "ec2:CreateNetworkInterface",
#                 "ec2:DeleteNetworkInterface",				
#                 "ec2:DescribeNetworkInterfaces",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeVpcAttribute",
#                 "iam:ListRolePolicies",
#                 "iam:GetRole",
#                 "iam:GetRolePolicy",
#                 "cloudwatch:PutMetricData"                
#             ],
#             "Resource": [
#                 "*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3: "
#             ],
#             "Resource": [
#                 "arn:aws:s3:::aws-glue-*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:GetObject",
#                 "s3:PutObject",
#                 "s3:DeleteObject"				
#             ],
#             "Resource": [
#                 "arn:aws:s3:::aws-glue-*/*",
#                 "arn:aws:s3:::*/*aws-glue-*/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:GetObject"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::crawler-public*",
#                 "arn:aws:s3:::aws-glue-*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents",
#                 "logs:AssociateKmsKey"                
#             ],
#             "Resource": [
#                 "arn:aws:logs:*:*:/aws-glue/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags",
#                 "ec2:DeleteTags"
#             ],
#             "Condition": {
#                 "ForAllValues:StringEquals": {
#                     "aws:TagKeys": [
#                         "aws-glue-service-resource"
#                     ]
#                 }
#             },
#             "Resource": [
#                 "arn:aws:ec2:*:*:network-interface/*",
#                 "arn:aws:ec2:*:*:security-group/*",
#                 "arn:aws:ec2:*:*:instance/*"
#             ]
#         }
#     ]
# }
# EOF
# }



resource "aws_iam_role" "aws_glue_role" {
  name               = "AWSGlueServiceRoleDefaultRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.aws_glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "my_s3_policy" {
  name   = "my_s3_policy"
  role   = aws_iam_role.aws_glue_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        var.datastore_bucket_arn,
        "${var.datastore_bucket_arn}/*"
      ]
    }
  ]
}
EOF
}