module "eso-secrets-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.44.0"
  
  name = "ESOSecretsManagerPolicy"
  path = "/"
  description = "WP Project Policy for AWS Secrets Manager and the External Secrets Operator (ESO)"

  policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds",
        "secretsmanager:CreateSecret",
        "secretsmanager:PutSecretValue",
        "secretsmanager:TagResource",
        "secretsmanager:DeleteSecret"
      ],
      "Resource": "${aws_secretsmanager_secret.wp-project-secret.arn}"
    }
  ]
}
EOF
tags = {
  Name = "WP Project External Secrets Operator Policy"
}
} 

module "eso-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.44.0"

  name          = "external-secrets"
  force_destroy = true
 
  password_reset_required = true

  create_iam_user_login_profile = false
  create_iam_access_key         = false # we create it later because we need them for ESO
  policy_arns                   = [module.eso-secrets-policy.arn]
}