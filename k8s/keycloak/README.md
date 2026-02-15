# Keycloak K8s Deployment

This directory contains the Kubernetes manifests for Keycloak and its PostgreSQL database, organized using Kustomize.

## Structure

- `base/`: Contains common resources (Deployments, Services, PVCs, Namespace, etc.).
- `overlays/`: Contains environment-specific configurations.
  - `local/`: Configuration for local development (KC_HOSTNAME: `auth.s4v3.local`).
  - `net/`: Configuration for network deployment (KC_HOSTNAME: `auth.s4v3.net`).

## Usage

To apply the configuration for a specific environment, use `kubectl apply -k <directory>`.

### Apply Local Configuration
```bash
kubectl apply -k k8s/keycloak/overlays/local
```

### Apply Net Configuration
```bash
kubectl apply -k k8s/keycloak/overlays/net
```

### Preview Manifests
If you want to see what will be applied without actually applying it:
```bash
kubectl kustomize k8s/keycloak/overlays/local
```
