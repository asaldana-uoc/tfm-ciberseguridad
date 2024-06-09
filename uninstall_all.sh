# Desinstalar Kyverno
helm uninstall kyverno kyverno/kyverno --namespace kyverno
kubectl delete namespace kyverno

# Desinstalar AWS Secrets and Configuration Provider (ASCP)
helm uninstall csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver -n kube-system
helm uninstall secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws -n kube-system

# Desinstalar Falco
helm uninstall falco -n falco
kubectl delete namespace falco

# Desinstalar Trivy-Operator
helm uninstall trivy-operator -n trivy-system
kubectl delete namespace trivy-system
kubectl delete crd vulnerabilityreports.aquasecurity.github.io
kubectl delete crd exposedsecretreports.aquasecurity.github.io
kubectl delete crd configauditreports.aquasecurity.github.io
kubectl delete crd clusterconfigauditreports.aquasecurity.github.io
kubectl delete crd rbacassessmentreports.aquasecurity.github.io
kubectl delete crd infraassessmentreports.aquasecurity.github.io
kubectl delete crd clusterrbacassessmentreports.aquasecurity.github.io
kubectl delete crd clustercompliancereports.aquasecurity.github.io
kubectl delete crd clusterinfraassessmentreports.aquasecurity.github.io
kubectl delete crd sbomreports.aquasecurity.github.io
kubectl delete crd clustersbomreports.aquasecurity.github.io
kubectl delete crd clustervulnerabilityreports.aquasecurity.github.io
