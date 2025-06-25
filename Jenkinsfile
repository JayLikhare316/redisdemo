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
                git url: 'https://github.com/JayLikhare316/redisdemo.git', branch: 'master'
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
                        terraform plan -out=tfplan
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'terraform/tfplan', allowEmptyArchive: true
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
                    script {
                        if (params.action == 'apply') {
                            sh '''
                                echo "=== Terraform Apply ==="
                                cd terraform/
                                terraform apply tfplan
                            '''
                        } else if (params.action == 'destroy') {
                            sh '''
                                echo "=== Terraform Destroy ==="
                                cd terraform/
                                terraform destroy --auto-approve
                            '''
                        }
                    }
                }
            }
        }

        stage('Wait for Infrastructure') {
            when {
                allOf {
                    expression { return params.autoApprove }
                    expression { return params.action == 'apply' }
                }
            }
            steps {
                echo "=== Waiting for infrastructure to be ready ==="
                sleep time: 60, unit: 'SECONDS'
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
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')
                ]) {
                    sh '''
                        echo "=== Running Ansible Playbook ==="
                        export ANSIBLE_HOST_KEY_CHECKING=False
                        ansible-playbook -i aws_ec2.yaml playbook.yml --private-key=$SSH_KEY
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Pipeline failed!'
            // Add notification logic here
        }
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
