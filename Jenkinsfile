pipeline {
    agent any

    environment {
        PROJECT_NAME = 'health_insurance_analytics'
        COMPOSE_PROJECT_NAME = 'healthpulse'

        // Permanent .env location on the EC2 server
        ENV_SOURCE = '/home/ubuntu/health_insurance_analytics/.env'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out latest code from GitHub...'
                checkout scm
            }
        }

        stage('Verify Files') {
            steps {
                sh '''
                    set -e

                    echo "Current workspace:"
                    pwd

                    echo "Project files:"
                    ls -la

                    test -f docker-compose.yml
                    test -f backend/Dockerfile
                    test -f frontend/Dockerfile
                    test -f nginx/default.conf

                    echo "Required project files are present."
                '''
            }
        }

        stage('Prepare Environment') {
            steps {
                sh '''
                    set -e

                    if [ ! -f "$ENV_SOURCE" ]; then
                        echo "ERROR: .env file not found at $ENV_SOURCE"
                        exit 1
                    fi

                    cp "$ENV_SOURCE" .env

                    chmod 600 .env

                    echo ".env copied successfully."
                '''
            }
        }

        stage('Validate Docker Compose') {
            steps {
                sh '''
                    set -e

                    docker compose config

                    echo "Docker Compose configuration is valid."
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    set -e

                    docker compose build

                    echo "Docker images built successfully."
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    set -e

                    docker compose up -d

                    echo "Application containers started."
                '''
            }
        }

        stage('Verify Containers') {
            steps {
                sh '''
                    set -e

                    sleep 10

                    docker compose ps

                    echo "Checking container status..."

                    docker compose ps | grep -E "healthpulse-(mysql|backend|frontend|nginx)"

                    echo "Containers are running."
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    set -e

                    echo "Checking frontend..."

                    curl -f http://localhost/ > /dev/null

                    echo "Frontend is working."

                    echo "Checking backend API..."

                    curl -f http://localhost/api/stats/summary > /dev/null

                    echo "Backend API is working."

                    echo "Health check successful."
                '''
            }
        }
    }

    post {

        success {
            echo '''
========================================
 Health Insurance Analytics Deployment
 SUCCESSFUL
========================================
'''
        }

        failure {
            echo '''
========================================
 Deployment FAILED
========================================

Showing container status and recent logs...
'''
            sh '''
                docker compose ps || true

                echo "===== Nginx Logs ====="
                docker compose logs --tail=50 nginx || true

                echo "===== Backend Logs ====="
                docker compose logs --tail=50 backend || true

                echo "===== Frontend Logs ====="
                docker compose logs --tail=50 frontend || true

                echo "===== MySQL Logs ====="
                docker compose logs --tail=50 mysql || true
            '''
        }

        always {
            sh '''
                rm -f .env
            '''
        }
    }
}
