#!/bin/bash

echo "- Grafana: http://localhost:3000"
echo "- Jaeger: http://localhost:8091"
echo "- Application: http://localhost:8080/"

kubectl port-forward -n monitoring svc/main-grafana 3000:80 &
kubectl port-forward -n monitoring svc/trace-jaeger-query 8091:80 &
kubectl port-forward -n application svc/application 8080:8080