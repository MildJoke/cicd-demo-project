pipeline {
    agent any
    
    environment {
        // Define environment variables
        APP_NAME = 'cicd-demo-app'
        DEPLOY_SERVER = '18.223.15.46'  // Your EC2 public IP
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                // For a simple HTML app, we don't need complex build steps
                sh 'echo "Build timestamp: $(date)" > build-info.txt'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Basic validation that our HTML file exists
                sh 'test -f index.html'
                sh 'echo "All tests passed!"'
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                echo 'Deploying to EC2 instance...'
                script {
                    // This assumes you have SSH keys configured
                    sh '''
                        # Copy files to EC2 instance
                        scp -i ~/.ssh/ec2-key.pem -r * ubuntu@${DEPLOY_SERVER}:/tmp/app/
                        
                        # Execute deployment script on EC2
                        ssh -i ~/.ssh/ec2-key.pem ubuntu@${DEPLOY_SERVER} 'cd /tmp/app && ./deploy.sh'
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Performing health check...'
                script {
                    sh '''
                        # Wait a moment for deployment to complete
                        sleep 10
                        
                        # Check if the application is responding
                        curl -f http://${DEPLOY_SERVER} || exit 1
                        echo "Health check passed!"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
