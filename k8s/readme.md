The following command from the project root:
`kubectl apply -k k8s`
You can verify the deployment with:

```kubectl get all -n keycloak-namespace```


kubectl port-forward svc/keycloak 8002:8080 -n keycloak-namespace