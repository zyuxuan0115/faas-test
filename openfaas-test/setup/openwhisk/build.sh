#!/bin/bash

ARGS=("$@")
IP=${ARGS[1]}

function setup {
#  helm repo add openwhisk https://openwhisk.apache.org/charts
#  helm repo update
#  helm install owdev openwhisk/openwhisk -n openwhisk --create-namespace -f - <<EOF
  helm install owdev ./helm-chart -n openwhisk --create-namespace -f - <<EOF
whisk:
  ingress:
    type: NodePort
    apiHostName: localhost
    apiHostPort: 32001
    apiHostProto: "http"
    useInternally: false

nginx:
  httpNodePort: 32001
  httpsNodePort: 31001

affinity:
  enabled: false
toleration:
  enabled: false
invoker:
  options: "-Dwhisk.kubernetes.user-pod-node-affinity.enabled=false"
  containerFactory:
    impl: "kubernetes"
EOF

  kubectl rollout status deployment/owdev-apigateway --namespace=openwhisk --timeout=600s
  kubectl rollout status deployment/owdev-nginx --namespace=openwhisk --timeout=600s

  # set openwhisk cli
  PORT=$(kubectl get svc -n openwhisk owdev-nginx -o jsonpath='{.spec.ports[?(@.port==80)].nodePort}') 
  wsk property set --apihost http://$IP:$PORT
  wsk property set --auth 23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
}

function kill_openwhisk {
  helm -n openwhisk uninstall owdev
  kubectl delete all --all -n openwhisk
  kubectl delete namespace openwhisk
  #python3 ../kill_port_fwd.py 31001:31001
}

function killa {
  kill_openwhisk
  rm -rf *.txt *.yaml *.yml
}

case "$1" in
setup)
    setup
    ;;
kill)
    killa
    ;;
kill_openwhisk)
    kill_openwhisk
    ;;
esac
