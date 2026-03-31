#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

unset DOCKER_TLS_VERIFY DOCKER_HOST DOCKER_CERT_PATH MINIKUBE_ACTIVE_DOCKERD

echo "==> Ensuring Minikube is running"
minikube config set autoPauseInterval 0 >/dev/null 2>&1 || true
minikube start --driver=docker --memory=2200 --cpus=2
kubectl config use-context minikube >/dev/null

echo "==> Deploying Prometheus"
kubectl apply -f k8s/monitoring/namespace.yml
kubectl apply -f k8s/monitoring/prometheus.yml
kubectl rollout status deployment/prometheus -n monitoring --timeout=300s

echo "==> Deploying Grafana"
kubectl apply -f k8s/monitoring/grafana.yml
kubectl rollout status deployment/grafana -n monitoring --timeout=300s

echo "==> Monitoring status"
kubectl get pods,svc -n monitoring

MINIKUBE_IP="$(minikube ip)"
echo "==> Prometheus URL: http://${MINIKUBE_IP}:30090"
echo "==> Grafana URL: http://${MINIKUBE_IP}:32000"
echo "==> Grafana credentials: admin / admin123"
