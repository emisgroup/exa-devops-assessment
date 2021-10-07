module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main_vpc"
  cidr = "10.0.0.0/16"

   azs = ["us-east-1a", "us-east-1b"]
   private_subnets = ["10.0.1.0/24", "10.0.5.0/24"]
   public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   
   enable_nat_gateway = true
   enable_vpn_gateway = false
}

# Outputs
output "emistest_vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "emistest_vpc_id" {
  value = module.vpc.vpc_id
}

