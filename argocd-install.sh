#!/bin/bash

NAMESPACE="argocd"
SECRET_NAME="argocd-initial-admin-secret"

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  -n $NAMESPACE \
  --create-namespace \
  -f ./argocd-values.yaml

until kubectl get secret $SECRET_NAME -n $NAMESPACE > /dev/null 2>&1; do
  echo "waiting for secret to generate..."
  sleep 2
done

echo "---------------------------------------------------"
echo "---------------------------------------------------"

echo "Secret found. Extracting password..."

ADMIN_PASSWORD=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.password}" | base64 -d)
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

echo "---------------------------------------------------"
echo "ArgoCD Admin Password: $ADMIN_PASSWORD"
echo "---------------------------------------------------"