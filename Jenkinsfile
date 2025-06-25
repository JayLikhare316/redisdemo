pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Poojabhanudevops/Redisdemo.git', branch: 'main'
            }
        }

        stage('Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        echo "=== Terraform Init ==="
                        cd terraform/
                        terraform init

                        echo "=== Terraform Validate ==="
                        terraform validate

                        echo "=== Terraform Plan ==="
                        terraform plan
                    '''
                }
            }
        }

        stage('Apply/Destroy') {
            when {
                expression { return params.autoApprove }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        echo "=== Terraform ${action} ==="
                        cd terraform/
                        terraform ${action} --auto-approve
                    '''
                }
            }
        }

        stage('Run Ansible Playbook') {
            when {
                allOf {
                    expression { return params.autoApprove }
                    expression { return params.action == 'apply' }
                }
            }
            steps {
                echo "=== Running Ansible Playbook ==="
                sh '''
                    ansible-playbook -i aws_ec2.yaml playbook.yml
                '''
            }
        }
    }
}
