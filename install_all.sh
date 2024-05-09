# Aplicar terraform
terraform -chdir=terraform apply -auto-approve

# Actualizar el archivo kubeconfig
rm -f ~/.kube/config
aws eks update-kubeconfig --region eu-south-2 --name tfm-asaldana-eks-cluster

# Instalar Kyverno
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --version 3.2.1 -n kyverno --create-namespace \
--set admissionController.replicas=3 \
--set backgroundController.replicas=2 \
--set cleanupController.replicas=2 \
--set reportsController.replicas=2

# Aplicar todas las políticas de Kyverno
kubectl apply -f kyverno/policies/workload
kubectl apply -f kyverno/policies/networking

# Instalar AWS Secrets and Configuration Provider (ASCP)
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
helm repo update
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --version 1.4.3 -n kube-system
helm install secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws --version 0.3.8 -n kube-system

# Instalar Falco en EKS
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
#helm install falco falcosecurity/falco --version 4.3.0 --create-namespace -n falco -f falco/values.yaml