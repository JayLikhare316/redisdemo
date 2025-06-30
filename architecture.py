
from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet, VPCPeering
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.iac import Terraform

with Diagram("Redis Infrastructure on AWS", show=False, filename="redis_infra_architecture"):
    jenkins = Jenkins("Jenkins")
    terraform = Terraform("Terraform")
    with Cluster("AWS Cloud"):
        with Cluster("VPC"):
            vpc = VPC("Main VPC")
            
            with Cluster("Public Subnets"):
                public_subnets = [PublicSubnet("Public Subnet 1"), PublicSubnet("Public Subnet 2")]

            with Cluster("Private Subnets"):
                private_subnets = [PrivateSubnet("Private Subnet 1"), PrivateSubnet("Private Subnet 2")]
                redis_instance = EC2("Redis Instance")
                private_subnets >> redis_instance
            
            peering = VPCPeering("VPC Peering")
            vpc >> peering
    
    jenkins >> terraform >> vpc
