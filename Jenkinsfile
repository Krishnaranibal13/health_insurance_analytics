pipeline {
    agent any

    environment {
        PROJECT_NAME = 'health_insurance_analytics'
        COMPOSE_PROJECT_NAME = 'healthpulse'

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

                    echo "Workspace:"
                    pwd

                    echo "Checking required files..."

                    test -f docker-compose.yml
                    test -f backend/Dockerfile
                    test -f frontend/Dockerfile
                    test -f nginx/default.conf

                    echo "Required files are present."
                '''
            }
        }

        stage('Prepare Environment') {
            steps {
                sh '''
                    set -e

                    echo "Checking deployment .env..."

                    test -f "$ENV_SOURCE"

                    cp "$ENV_SOURCE" .env

                    chmod 600 .env

                    echo ".env prepared successfully."
                '''
            }
        }

        stage('Docker Access') {
            steps {
                sh '''
                    set -e

                    echo "Checking Docker access..."

                    docker version

                    echo "Docker access is working."
                '''
            }
        }

        stage('Validate Docker Compose') {
            steps {
                sh '''
                    set -e

                    docker compose config > /tmp/healthpulse-compose-config.yml

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

                    echo "Application deployed."
                '''
            }
        }

        stage('Verify Containers') {
            steps {
                sh '''
                    set -e

                    sleep 10

                    docker compose ps

                    echo "Checking required containers..."

                    docker inspect -f '{{.State.Status}}' healthpulse-mysql | grep -q running
                    docker inspect -f '{{.State.Status}}' healthpulse-backend | grep -q running
                    docker inspect -f '{{.State.Status}}' healthpulse-frontend | grep -q running
                    docker inspect -f '{{.State.Status}}' healthpulse-nginx | grep -q running

                    echo "All containers are running."
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    set -e

                    echo "Checking frontend..."

                    curl -f http://localhost/ > /dev/null

                    echo "Frontend OK."

                    echo "Checking backend API..."

                    curl -f http://localhost/api/stats/summary > /dev/null

                    echo "Backend API OK."

                    echo "Health check successful."
                '''
            }
        }
    }

    post {

        success {
            echo '''
========================================
 HealthPulse Deployment SUCCESSFUL
========================================
'''
        }

        failure {
            echo '''
========================================
 HealthPulse Deployment FAILED
========================================
'''
        }

        always {
            sh '''
                rm -f .env
            '''
        }
    }
}
