## How to install Rook on K8S Xena Cluster
# switch to XENA CLUSTER
xena

helm repo add rook-release https://charts.rook.io/release
helm repo update

# Ensure the namespace exists
kubectl create namespace rook-ceph

# 1. Generate the manifests (This should work now!)
cd xena-rook-cluster
helm template rook-ceph rook-release/rook-ceph \
--namespace rook-ceph \
--version v1.19.0 \
--values ./values.yaml \
--include-crds > ./operator-generated.yaml

# 2. Apply the Operator & CRDs
kubectl apply -f ./operator-generated.yaml

# 1. Ensure the namespace exists
kubectl create namespace rook-ceph --dry-run=client -o yaml | kubectl apply -f -

# 2. Apply the generated operator file using 'create' or '--server-side'
# --server-side is the modern 2026 way to handle large CRDs
kubectl apply -f ./operator-generated.yaml --server-side

# 3. Now apply your specific Cluster and Storage settings
kubectl apply -f ./cluster.yaml
kubectl apply -f ./ceph-storage.yaml

# 3. Wait 300 seconds for the CRDs to settle, then apply your Cluster & PVs
sleep 300
kubectl apply -f ./ceph-pvc.yaml

# 4. Check status
kubectl -n rook-ceph get pods

# 5. Allow all nodes to use Ceph
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

# 6. Check cluster installation progress health status
kubectl -n rook-ceph get cephcluster
#NAME        DATADIRHOSTPATH   MONCOUNT   AGE     PHASE         MESSAGE                  HEALTH   EXTERNAL   FSID
#rook-ceph   /var/lib/rook     3          3m13s   Progressing   Detecting Ceph version   
kubectl -n rook-ceph get cephcluster
#NAME        DATADIRHOSTPATH   MONCOUNT   AGE   PHASE   MESSAGE                        HEALTH        EXTERNAL   FSID
#rook-ceph   /var/lib/rook     3          17m   Ready   Cluster created successfully   HEALTH_WARN              98fa2d97-3c17-4209-bf03-c8a6c066b555