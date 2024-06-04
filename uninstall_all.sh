# Desinstalar Kyverno
helm uninstall kyverno kyverno/kyverno --namespace kyverno
kubectl delete namespace kyverno

# Desinstalar AWS Secrets and Configuration Provider (ASCP)
helm uninstall csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver -n kube-system
helm uninstall secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws -n kube-system

# Desinstalar Falco
helm uninstall falco -n falco
kubectl delete namespace falco

# Desinstalar Trivy
helm uninstall trivy-operator -n trivy-system
kubectl delete namespace trivy-system
