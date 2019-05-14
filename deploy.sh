#!/bin/bash -eu

kubectl config use-context docker-for-desktop

APP_NAME="nginx-deployment"

kubectl delete deployment $APP_NAME
kubectl delete limits cpu-limit-range

echo
kustomize build | kubectl apply -f -

echo
echo "============================="
echo "Limits:"
kubectl get limits
echo "============================="

POD_INFO=$(kubectl get pods -l "app=${APP_NAME}" -o json)
POD_NAME="$(echo ${POD_INFO} | jq -r '.items[0].metadata.name')"

echo "============================="
echo "Quality of Service Class:"
kubectl get pod $POD_NAME -o json | jq -r '.status.qosClass'
echo "============================="
echo

echo "============================="
echo "Compute Resources:"
kubectl get pod $POD_NAME -o json | jq -r '.spec.containers[].resources'
echo "============================="

echo
echo "============================="
echo "Pods:"
kubectl get pods
echo "============================="

echo
echo "============================="
echo "Pod condition:"
kubectl get pod $POD_NAME -o json | jq -r '.status.conditions[].message'
echo "============================="

