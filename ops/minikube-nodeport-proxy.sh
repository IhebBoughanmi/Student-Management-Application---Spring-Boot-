#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <local-port> <node-port>" >&2
  exit 1
fi

local_port="$1"
node_port="$2"
minikube_ip="${MINIKUBE_IP:-$(minikube ip)}"

exec socat \
  TCP-LISTEN:"${local_port}",fork,reuseaddr \
  TCP:"${minikube_ip}:${node_port}"
