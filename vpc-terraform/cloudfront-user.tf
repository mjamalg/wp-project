module "cloudfront-wp-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.44.0"

  #user to use to configure W3-Cache cloudfront 
  name          = "wpcdn"
  force_destroy = true
 
  password_reset_required = false

  create_iam_user_login_profile = false
  create_iam_access_key         = false #we'll create them in eks-ansible/roles/bitnami-wordpress-install
  policy_arns                   = [ "arn:aws:iam::aws:policy/CloudFrontFullAccess" ]
}