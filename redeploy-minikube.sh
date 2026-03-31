#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

unset DOCKER_TLS_VERIFY DOCKER_HOST DOCKER_CERT_PATH MINIKUBE_ACTIVE_DOCKERD

echo "==> Ensuring Minikube is running"
minikube config set autoPauseInterval 0 >/dev/null 2>&1 || true
minikube start --driver=docker --memory=2200 --cpus=2
kubectl config use-context minikube >/dev/null

echo "==> Building the Spring Boot jar"
./mvnw clean package -DskipTests

echo "==> Pulling base images if needed"
docker image inspect eclipse-temurin:17-jre >/dev/null 2>&1 || docker pull eclipse-temurin:17-jre
docker image inspect mysql:8 >/dev/null 2>&1 || docker pull mysql:8

echo "==> Building the application image"
docker build -t student-management:local .

echo "==> Loading images into Minikube"
minikube image load student-management:local
minikube image load mysql:8

echo "==> Deploying MySQL"
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/mysql-service.yml
kubectl rollout status deployment/mysql --timeout=300s

echo "==> Deploying the application"
kubectl apply -f k8s/app-deployment.yml
kubectl apply -f k8s/app-service.yml
kubectl rollout status deployment/student-app --timeout=300s

echo "==> Current workload status"
kubectl get nodes
kubectl get pods,svc

echo "==> Application URL"
minikube service student-service --url
