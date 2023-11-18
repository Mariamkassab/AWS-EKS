#aws region
aws-region = "us-east-1" #eu-west-1

# vpc & internet gatway
vpc_cidr = "10.0.0.0/16"
vpc_name = "terraform vpc"
gw_name  = "terraform internet gateway"

# subnets
subnet_cidr    = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
az             = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1b", "us-east-1a", "us-east-1b" ] #["eu-west-1a", "eu-west-1a", "eu-west-1b", "eu-west-1b", "eu-west-1a", "eu-west-1b" ]
subnet_name    = ["pub_sub1_az1", "private_sub1_az1", "private_sub2_az2", "pub_sub2_az2", "private_sub3_az1", "private_sub4_az2" ]

# nat
nat_name         = "nat_gateway"

# #lb security group
# lb-ec2-cidr = ["10.0.2.0/24" , "10.0.1.0/24"]

# #endpoint security group
# endpoint-ssh-cidr = ["10.0.2.0/24", "10.0.1.0/24"] 

# route tables 
pub-wanted-cidr = "0.0.0.0/0"
pub-table-name = "public_rt"

pri-wanted-cidr = "0.0.0.0/0"
pri-table-name = "private_rt"

#eks-cluster
cluster_name = "my-eks-cluster"
node_group_name = "my-eks-node-group"

#mysql-rds
engine-name = "mysql"
db-name = "my-rds"
storage = 5
max_allocated_storage-autoscalling = 10
engine-v = "5.7" # the new verion 
instance-type = "db.t2.micro"
user = "myrdsuser"
skip-final-db-snapshot = true  #should be false
monitoring_interval = 30
maintenance_window = "Mon:00:00-Mon:03:00"
backup_window = "03:00-06:00"
backup_retention_period = 0
secret-name = "db-password-axir"
rds-enhanced-monitoring-role = "rds-monitoring-in-enhanced-details"
