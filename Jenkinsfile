pipeline {
    agent any

    tools {
        maven 'M2_HOME'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/IhebBoughanmi/Student-Management-Application---Spring-Boot-.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                          mvn -B verify -DskipTests \
                          org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar \
                          -Dsonar.projectKey=Student-Management
                        '''
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                  docker build -t ihebboughanmi/student-management:latest .
                  docker push ihebboughanmi/student-management:latest
                '''
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                  docker rm -f mysql-db student-app || true
                  docker compose down --remove-orphans || true
                  docker compose pull
                  docker compose up -d
                '''
            }
        }
    }
}
