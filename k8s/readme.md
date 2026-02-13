The following command from the project root:
`kubectl apply -k k8s`
You can verify the deployment with:

kubectl get all -n keycloak-namespace

## Exposing 
Either:
kubectl port-forward svc/keycloak 8002:8080 -n keycloak-namespace

(Deprecated)
Or, if Ingress is enabled:
kubectl apply -f kind/keycloak-ingress.yaml

Use the Gateway in K8S