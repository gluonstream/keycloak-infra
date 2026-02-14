#!/bin/zsh
echo "Hello K8S Kind Cluster"
kind create cluster --config kind/kind-cluster.yaml
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.4.1/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.4.1/deploy/default/deploy.yaml
kubectl apply -f kind/nginx-proxy-config.yaml
kubectl get gatewayclass