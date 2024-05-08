# Apply terraform
terraform -chdir=terraform apply -auto-approve

# Update kubeconfig
aws eks update-kubeconfig --region eu-south-2 --name tfm-asaldana-eks-cluster

# Install Kyverno
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno  --version 3.2.1 -n kyverno --create-namespace \
--set admissionController.replicas=3 \
--set backgroundController.replicas=2 \
--set cleanupController.replicas=2 \
--set reportsController.replicas=2

# Apply all Kyverno policies
kubectl apply -f kyverno/policies/workload