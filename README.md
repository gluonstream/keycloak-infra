# Gateway API Setup

# TL;DR 
```bash
./cluster_kind_setup.sh
```

## 0. Create Kind Cluster with Gateway Support

```bash
kind create cluster --config kind/kind-cluster.yaml
```

## 1. Install Gateway API CRDs

```bash
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml
```

## 2. Install a Gateway Controller

Installing CRDs is only the first step. You also need a controller that implements the Gateway API.

### Option A: NGINX Gateway Fabric (Recommended by existing manifests)

The manifests in the `k8s/` folder are configured to use `gatewayClassName: nginx`. To use them as-is, install NGINX Gateway Fabric:

1. Install NGINX Gateway Fabric CRDs:
```bash
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.4.1/deploy/crds.yaml
```
2. Install the controller:
```bash
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.4.1/deploy/default/deploy.yaml
```
3. Apply the NGINX Gateway configuration (might need to apply -k k8s first)
```bash
kubectl apply -f kind/nginx-proxy-config.yaml
```
This will update the NGINX Gateway proxy pods to bind to port 80 and 443 on the Kind node. Large file uploads are configured via a `ClientSettingsPolicy` targeting the `Gateway` (see `k8s/keycloak-gateway-nginx.yaml`).

## 4. Verify Installation

```bash
kubectl get gatewayclass
```
After installing the CRDs and a controller, you should be able to apply the manifests in the `k8s/` folder without errors:

```bash
kubectl apply -k k8s/nginx-gateway
kubectl apply -k k8s/keycloak
```
