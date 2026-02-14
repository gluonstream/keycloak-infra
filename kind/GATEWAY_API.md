# Gateway API Setup

## 0. Create Kind Cluster with Gateway Support
yes but can you hear me ?

```bash
kind create cluster --config kind/kind-cluster.yaml
```

This configuration also adds the `gateway-ready=true` label to the control-plane node.

## 1. Install Gateway API CRDs

To resolve this, run the following command:

```bash
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml
```


*Note: You can use a newer version if available.*

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

### Option B: Kong Gateway

If you prefer to use Kong Gateway, follow these steps to install the controller (KIC 3.x) and apply the configuration:

1. **Install Kong Ingress Controller via Helm** (Recommended):
   ```bash
   helm repo add kong https://charts.konghq.com
   helm repo update
   helm install kong kong/kong -n default \
     --set ingressController.installCRDs=false \
     --set ingressController.gateway.enabled=true \
     --set ingressController.gateway.controllerName=konghq.com/kic-gateway-controller \
     --set ingressController.env.CONTROLLER_GATEWAY_API_CONTROLLER_NAME=configuration.konghq.com/gateway-controller \
     --set proxy.http.hostPort=80 \
     --set proxy.type=NodePort 
   ```
   *Note: If you already installed Kong without these flags, you can upgrade it with the same command but using `upgrade` instead of `install`.*

2. **Wait for Kong to be ready**:
   ```bash
   kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=kong -n default --timeout=300s
   ```

3. **Apply the Kong-specific gateway configuration**:
   ```bash
   kubectl apply -f kind/old/keycloak-kong-gateway.yaml
   ```

This file includes the `GatewayClass` (using `controllerName: konghq.com/kic-gateway-controller`), `Gateway`, and `HTTPRoute` for Keycloak. Once the controller is running, the `GatewayClass` status will change from `Unknown` to `True`.

## 3. (Mandatory) Configure NGINX for Kind (Host Access)
If you are using Kind with the port mappings from `kind/kind-cluster.yaml`, you need to configure the NGINX Gateway to use `hostPort` so it can receive traffic from the host:

```bash
kubectl apply -f kind/nginx-proxy-config.yaml
```

This will update the NGINX Gateway proxy pods to bind to port 80 and 443 on the Kind node. Large file uploads are configured via a `ClientSettingsPolicy` targeting the `Gateway` (see `k8s/keycloak-gateway-nginx.yaml`).

## 4. Verify Installation

Check that the GatewayClasses are recognized:

```bash
kubectl get gatewayclass
```

After installing the CRDs and a controller, you should be able to apply the manifests in the `k8s/` folder without errors:

```bash
kubectl apply -k k8s
```
