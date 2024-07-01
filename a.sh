#!/bin/bash

# Uninstall existing Nginx Ingress Controllers
helm uninstall nginx-ingress-1 -n ingress-nginx-1
helm uninstall nginx-ingress-2 -n ingress-nginx-2
helm uninstall nginx-ingress-3 -n ingress-nginx-3

# Delete the namespaces
kubectl delete namespace ingress-nginx-1
kubectl delete namespace ingress-nginx-2
kubectl delete namespace ingress-nginx-3

# Delete all IngressClass resources
kubectl delete ingressclass --all

# Wait for resources to be fully deleted
echo "Waiting for resources to be deleted..."
sleep 30

# Add the Nginx Ingress repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install the first Nginx Ingress Controller
helm install custom-ingress-1 ingress-nginx/ingress-nginx \
  --namespace custom-ingress-1 \
  --create-namespace \
  --set controller.ingressClassResource.name=custom-nginx-1 \
  --set controller.ingressClassResource.controllerValue="k8s.io/custom-ingress-nginx-1" \
  --set controller.ingressClassByName=true

# Install the second Nginx Ingress Controller
helm install custom-ingress-2 ingress-nginx/ingress-nginx \
  --namespace custom-ingress-2 \
  --create-namespace \
  --set controller.ingressClassResource.name=custom-nginx-2 \
  --set controller.ingressClassResource.controllerValue="k8s.io/custom-ingress-nginx-2" \
  --set controller.ingressClassByName=true

# Install the third Nginx Ingress Controller
helm install custom-ingress-3 ingress-nginx/ingress-nginx \
  --namespace custom-ingress-3 \
  --create-namespace \
  --set controller.ingressClassResource.name=custom-nginx-3 \
  --set controller.ingressClassResource.controllerValue="k8s.io/custom-ingress-nginx-3" \
  --set controller.ingressClassByName=true

echo "Installation completed. Please check the status of the pods."