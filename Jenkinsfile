pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    agent any

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
                        cd terraform/
                        terraform init
                        terraform validate
                        terraform plan
                    '''
                }
            }
        }

        stage('Apply/Destroy') {
            when {
                expression { return params.autoApprove } // only run if autoApprove is true
            }
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        cd terraform/
                        terraform ${action} --auto-approve
                    '''
                }
            }
        }

        stage('Run Ansible Playbook') {
            when {
                expression { return params.action == 'apply' }
            }
            steps {
                echo "Running Ansible Playbook..."
                sh 'ansible-playbook -i aws_ec2.yaml playbook.yml'
            }
        }
    }
}
