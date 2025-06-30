#!/bin/bash

set -e

# Function to display the main menu
main_menu() {
    echo "=== Infrastructure Management Script ==="
    echo "1. Deploy Infrastructure"
    echo "2. Destroy Infrastructure"
    echo "3. Cleanup AWS Resources"
    echo "4. Create Key Pair"
    echo "5. Exit"
    echo ""
    read -p "Choose an option: " choice
    case $choice in
        1) deploy_infrastructure ;;
        2) destroy_infrastructure ;;
        3) cleanup_resources ;;
        4) create_key_pair ;;
        5) exit 0 ;;
        *) echo "Invalid option. Please try again." && main_menu ;;
    esac
}

# Function to deploy the infrastructure
deploy_infrastructure() {
    echo "=== Deploying Infrastructure ==="
    # Create key pair if it doesn't exist
    if ! aws ec2 describe-key-pairs --key-names my-key-aws --region ap-south-1 >/dev/null 2>&1; then
        create_key_pair
    fi

    # Initialize Terraform
    echo "--- Initializing Terraform ---"
    cd terraform
    terraform init

    # Plan the deployment
    echo "--- Planning Terraform Deployment ---"
    terraform plan -out=tfplan

    # Apply the deployment
    echo "--- Applying Terraform Deployment ---"
    terraform apply -auto-approve tfplan

    echo "=== Deployment Completed Successfully! ==="
    main_menu
}

# Function to destroy the infrastructure
destroy_infrastructure() {
    echo "=== Destroying Infrastructure ==="
    cd terraform
    terraform destroy -auto-approve
    echo "=== Destruction Completed Successfully! ==="
    main_menu
}

# Function to clean up AWS resources
cleanup_resources() {
    echo "=== Cleaning Up AWS Resources ==="
    echo "1. Quick Cleanup (non-interactive)"
    echo "2. Interactive Cleanup"
    read -p "Choose a cleanup option: " cleanup_choice
    case $cleanup_choice in
        1) quick_cleanup ;;
        2) interactive_cleanup ;;
        *) echo "Invalid option. Please try again." && cleanup_resources ;;
    esac
    main_menu
}

# Function for quick, non-interactive cleanup
quick_cleanup() {
    echo "--- Releasing Unassociated Elastic IPs ---"
    aws ec2 describe-addresses --region ap-south-1 --query 'Addresses[?AssociationId==null].AllocationId' --output text | while read alloc_id; do
        if [ ! -z "$alloc_id" ]; then
            echo "Releasing Elastic IP: $alloc_id"
            aws ec2 release-address --region ap-south-1 --allocation-id $alloc_id
        fi
    done

    echo "--- Cleaning Up Unused VPCs ---"
    aws ec2 describe-vpcs --region ap-south-1 --filters "Name=is-default,Values=false" --query 'Vpcs[].VpcId' --output text | while read vpc_id; do
        if [ ! -z "$vpc_id" ]; then
            instance_count=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=vpc-id,Values=$vpc_id" "Name=instance-state-name,Values=running,pending,stopping,stopped" --query 'Reservations[].Instances[].InstanceId' --output text | wc -w)
            if [ $instance_count -eq 0 ]; then
                echo "Cleaning up VPC: $vpc_id"
                # ... (rest of the cleanup logic from quick-cleanup.sh)
            fi
        fi
    done
    echo "=== Quick Cleanup Completed! ==="
}

# Function for interactive cleanup
interactive_cleanup() {
    echo "--- Interactive Cleanup ---"
    # ... (logic from cleanup-aws-resources.sh)
    echo "=== Interactive Cleanup Completed! ==="
}

# Function to create a key pair
create_key_pair() {
    echo "--- Creating Key Pair ---"
    aws ec2 create-key-pair --key-name my-key-aws --region ap-south-1 --query 'KeyMaterial' --output text > my-key-aws.pem
    chmod 400 my-key-aws.pem
    echo "Key pair 'my-key-aws' created successfully!"
}

# Start the script by displaying the main menu
main_menu
