pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
                sh 'pwd;cd terraform/ ; terraform init'
                sh 'pwd;cd terraform/ ; terraform validate'
                sh 'pwd;cd terraform/ ; terraform plan'
            }
        }

        stage('Apply/Destroy') {
            steps {
                sh 'pwd;cd terraform/ ; terraform ${action} --auto-approve'
            }
        }

        // New stage to run the Ansible playbook after Apply
        stage('Run Ansible Playbook') {
            when {
                expression {
                    return params.action == 'apply'  // Run only if the action is 'apply'
                }
            }
            steps {
                script {
                    // Ensure that the Ansible playbook is executed only if terraform apply was successful
                    echo "Running Ansible Playbook..."
                    sh 'ansible-playbook -i aws_ec2.yaml playbook.yml'  // Playbook name
                }
            }
        }
    }
}
