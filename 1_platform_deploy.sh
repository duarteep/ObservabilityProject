#!/bin/bash

# Deploy k8s cluster using Kind
kind create cluster --name sre-cluster --config infra/kind/values.yaml

# Useful Helm repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kedacore https://kedacore.github.io/charts
helm repo add stable https://charts.helm.sh/stable
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

# Deploy Keda
helm install keda kedacore/keda --namespace keda --create-namespace

# Deploy Kube Prometheus stack
helm upgrade -i main prometheus-community/kube-prometheus-stack --namespace monitoring -f infra/kube-prometheus/values.yaml --create-namespace

# Deploy Grafana Loki stack
helm upgrade -i loki grafana/loki-stack -n monitoring -f infra/grafana-loki/values.yaml --create-namespace

# Deploy Jaeger
# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml
helm upgrade -i trace jaegertracing/jaeger -n monitoring -f infra/jaeger/values.yaml --create-namespace
