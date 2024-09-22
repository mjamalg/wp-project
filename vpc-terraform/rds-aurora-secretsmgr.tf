
/* Note 1: to use a kubernetes secret containg DB credentials with Bitnami Wordpress, it looks for a key called 
"mariadb-password" for the database password. Its hardcoded :-( 

   Note 2: Once a secret is created and it's not destroyed
  every time you run a terraform apply it will generate a new password O.o Working as intended
*/

locals {

  rds_auth = {
    username = "wpdbadmin"
    mariadb-password = "${data.aws_secretsmanager_random_password.wp-project-random-password.random_password}" 
  }

  secrets_name = format("wp-project-aurora-db-secret-%s",random_string.wp-project-secret-name-str.id)
  # AWS Secrets aren't fully deleted for a minimum of seven days. If you destroy this environment
  # and recreate it (as you should!), you wont be able to use the secrets name again for about 7 days. This generates a new 
  # randomized name every time you create one.
}

resource "random_string" "wp-project-secret-name-str" {
  length   = 16
  special  = false
  upper    = false
}

resource "aws_secretsmanager_secret" "wp-project-secret" {
  name = local.secrets_name
  tags = {
    Name = "WP Project Aurora Secret"
  }

}

resource "aws_secretsmanager_secret_version" "wp-project-secret-version" {
  secret_id = aws_secretsmanager_secret.wp-project-secret.id
  secret_string = jsonencode(local.rds_auth)

  lifecycle {
    ignore_changes = [
      secret_string, id
     ]
  }

}

data "aws_secretsmanager_random_password" "wp-project-random-password" {
  password_length = 32
  exclude_characters = "@\"/\\"

}

