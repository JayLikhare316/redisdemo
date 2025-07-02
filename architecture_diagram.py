
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, PublicSubnet, PrivateSubnet, InternetGateway, NATGateway, ElbApplicationLoadBalancer
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.vcs import Github
from diagrams.onprem.iac import Ansible, Terraform

with Diagram("Redis Infra Architecture", show=False, filename="redis_infra_architecture", direction="LR"):

    github = Github("GitHub")

    with Cluster("CI/CD Pipeline"):
        github_actions = GithubActions("GitHub Actions")

    with Cluster("AWS Cloud"):
        with Cluster("VPC"):
            igw = InternetGateway("Internet Gateway")
            nat = NATGateway("NAT Gateway")

            with Cluster("Public Subnet"):
                public_instance = EC2("Public Instance")

            with Cluster("Private Subnet"):
                private_instances = [
                    EC2("Private Instance 1"),
                    EC2("Private Instance 2"),
                    EC2("Private Instance 3")
                ]

            igw >> public_instance
            public_instance >> nat
            nat >> private_instances[0]
            nat >> private_instances[1]
            nat >> private_instances[2]

    with Cluster("Configuration Management"):
        ansible = Ansible("Ansible")

    with Cluster("Infrastructure as Code"):
        terraform = Terraform("Terraform")

    github >> github_actions
    github_actions >> terraform
    terraform >> igw
    terraform >> nat
    terraform >> public_instance
    terraform >> private_instances
    github_actions >> ansible
    ansible >> private_instances
