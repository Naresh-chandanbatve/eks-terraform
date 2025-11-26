#!/bin/bash

NAMESPACE="default"
RELEASE="app"
CHART="./helm"

# Name of your ingress controller service
INGRESS_SVC="nginx-ingress-nginx-controller"
INGRESS_NS="ingress-nginx"

echo "Waiting for Ingress LoadBalancer Hostname..."
HOST=""

while [ -z "$HOST" ]; do
  HOST=$(kubectl get svc $INGRESS_SVC -n $INGRESS_NS -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)
  sleep 5
done

echo "Using domain: $HOST"

helm upgrade --install $RELEASE $CHART \
  --namespace $NAMESPACE \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=$HOST \
  --set ingress.tls[0].hosts[0]=$HOST \
  --set ingress.hosts[0].paths[0].path="/" \
  --set ingress.hosts[0].paths[0].pathType=Prefix \
  --set ingress.tls[0].secretName=app-tls

echo "Application deployed suscessfully!"
