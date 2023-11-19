module "terraform_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  gw_name  = var.gw_name
}

module "terraform_subnet" {
  source         = "./modules/subnet"
  created_vpc_id = module.terraform_vpc.vpc_id
  subnet_cidr    = var.subnet_cidr
  az             = var.az
  subnet_name    = var.subnet_name
}

module "nat_gateway" {
  source           = "./modules/nat"
  public_subnet_id = module.terraform_subnet.first_pub_id
  nat_name         = var.nat_name
}

module "eks_nodes_security_group" {
  source         = "./modules/security-group"
  created_vpc_id = module.terraform_vpc.vpc_id

  ingress_rules = {
  connect = {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = [] 
      security_group = [module.bastion_host_security_group.sg_id]
    }
  }

  egress_rules = { 
    all = {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      security_group = []
    }
  }

  sc_g_name = "eks_nodes_security_group"
}



module "rds_security_group" {
  source         = "./modules/security-group"
  created_vpc_id = module.terraform_vpc.vpc_id

  ingress_rules = {
    ec2 = {
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.32.0/19", "10.0.64.0/19"]
      security_group = [] 
    }
  }

  egress_rules = {
    no-rules = {
      port        = 0
      protocol    = ""
      cidr_blocks = []
      security_group = []

    }
  }

  sc_g_name = "rds_security_group"
}

module "bastion_host_security_group" {
  source         = "./modules/security-group"
  created_vpc_id = module.terraform_vpc.vpc_id

  ingress_rules = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] #only my public ip
      security_group = []
    }
  }

  egress_rules = {
    no-rules = {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      security_group = []

    }
  }

  sc_g_name = "bastion_host_security_group"
}


# module "endpoint_security_group" {
#   source         = "./modules/security-group"
#   created_vpc_id = module.terraform_vpc.vpc_id

#   ingress_rules = {
#     no-rules = {
#       port        = 0
#       protocol    = ""
#       cidr_blocks = []   # my public ip
#       security_group = [] 
#     }
#   }

#   egress_rules = {
#     ec2 = {
#       port        = 22
#       protocol    = "tcp"
#       cidr_blocks = var.endpoint-ssh-cidr
#       security_group = []

#     }
#   }

#   sc_g_name = "endpoint_security_group"
# }

module "public_routing_table" {
  source         = "./modules/route_table"
  created_vpc_id = module.terraform_vpc.vpc_id
  wanted_cidr    = var.pub-wanted-cidr 
  needed_gatway  = module.terraform_vpc.internet_gateway_id
  table_name     = var.pub-table-name
  chosen_subnets  = [module.terraform_subnet.first_pub_id , module.terraform_subnet.second_pub_id]
   } 


module "private_routing_table" {
  source         = "./modules/route_table"
  created_vpc_id = module.terraform_vpc.vpc_id
  wanted_cidr    = var.pri-wanted-cidr 
  needed_gatway  = module.nat_gateway.nat_id
  table_name     = var.pri-table-name 
  chosen_subnets  = [module.terraform_subnet.first_pri_id, module.terraform_subnet.second_pri_id]
   } 


# module "eks-cloudwatch" {
#   source = "./modules/EKS/EKS-cloud-watch"
#   cluster_name = var.cluster_name
#   depends_on = [ module.eks-cluster ]
# }
module "eks-iam-roles" {
  source = "./modules/EKS/iam-roles"
}

module "EKS-cluster" {
  source = "./modules/EKS/cluster-master"
  cluster_name = var.cluster_name
  eks-role = module.eks-iam-roles.master-role-arn
  subnet_ids = [ module.terraform_subnet.first_pri_id , module.terraform_subnet.second_pri_id ]
  cluster-security-group = [ module.eks_nodes_security_group.sg_id ]
  depends_on = [ module.eks-iam-roles ]
}

module "EKS-node_group" {
  source = "./modules/EKS/eks-node-group"
  cluster_name = module.EKS-cluster.eks-cluster-name
  node_group_name = var.node_group_name
  node_role_arn = module.eks-iam-roles.node-group-role-arn
  subnet_ids = [ module.terraform_subnet.first_pri_id , module.terraform_subnet.second_pri_id ]
  key_name = module.bastion-host.ssh_key_name
  depends_on = [ module.eks-iam-roles ]
}

module "mysql-rds" {
  source = "./modules/RDS"
  engine-name = var.engine-name
  db-name = var.db-name
  storage = var.storage
  engine-v = var.engine-v
  instance-type = var.instance-type
  user = var.user
  subnet-vpc-id = [ module.terraform_subnet.third_pri_id , module.terraform_subnet.forth_pri_id ]
  skip-final-db-snapshot = var.skip-final-db-snapshot
  db-security-group = module.rds_security_group.sg_id
  max_allocated_storage-autoscalling = var.max_allocated_storage-autoscalling
  monitoring_interval = var.monitoring_interval
  maintenance_window = var.maintenance_window 
  backup_window = var.backup_window
  backup_retention_period = var.backup_retention_period
  secret-name = var.secret-name
  rds-enhanced-monitoring-role = var.rds-enhanced-monitoring-role
}

module "bastion-host" {
  source = "./modules/ec2-bastion-host"
  pub_subnet = module.terraform_subnet.second_pub_id
  bastion-host-security-group = [ module.bastion_host_security_group.sg_id ]
}

module "ecr_registry" {
  source = "./modules/ECR"  
}