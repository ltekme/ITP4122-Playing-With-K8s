/*########################################################
Main RDS cluster

########################################################*/
module "aurora_mysql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.4.0"

  name = lower("${var.project_name}-VTC-Service-Main-mysql-aurora")

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "8.0"

  database_name = var.Moodle-Database-Name

  master_username                     = var.rds-master-user
  master_password                     = var.rds-master-password
  iam_database_authentication_enabled = false
  manage_master_user_password         = false
  publicly_accessible                 = true

  vpc_id               = aws_vpc.VTC-Service.id
  db_subnet_group_name = aws_db_subnet_group.VTC_Service-MAIN_RDS.name

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [
        aws_subnet.VTC_Service-private-AZ_A.cidr_block,
        aws_subnet.VTC_Service-private-AZ_B.cidr_block,
        "0.0.0.0/0" # For Public Access
      ]
    }
  }

  storage_encrypted = true
  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
  }
}
