# Desinstalar Kyverno
helm uninstall kyverno kyverno/kyverno --namespace kyverno

# Desinstalar AWS Secrets and Configuration Provider (ASCP)
helm uninstall csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver -n kube-system
helm uninstall secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws -n kube-system

# Desinstalar Falco en EKS
helm uninstall falco -n falco