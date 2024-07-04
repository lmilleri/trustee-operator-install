#!/bin/bash

HTTPS="${HTTPS:-NO}"

source ../common.sh

if [[ $HTTPS == "YES" || $HTTPS == "yes" ]]; then
  # create https key/certificate
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout https.key -out https.crt \
    -config kbs-service-509.conf -passin pass:\
    -subj "/C=UK/ST=England/L=Bristol/O=Red Hat/OU=Development/CN=kbs-service"
  oc delete secret kbs-https-certificate
  oc delete secret kbs-https-key
  oc create secret generic kbs-https-certificate --from-file=https.crt -n kbs-operator-system
  oc create secret generic kbs-https-key --from-file=https.key -n kbs-operator-system
fi

# create keys
openssl genpkey -algorithm ed25519 > privateKey
openssl pkey -in privateKey -pubout -out publicKey
oc delete secret kbs-auth-public-key
oc create secret generic kbs-auth-public-key --from-file=publicKey -n kbs-operator-system

oc apply -f as-config.yaml

oc apply -f rvps-config.yaml

#oc apply -f reference-values.yaml

oc create secret generic kbsres1 --from-literal key1=res1val1 --from-literal key2=res1val2 -n kbs-operator-system

if [[ $HTTPS == "YES" || $HTTPS == "yes" ]]; then
  oc apply -f kbs-config-https.yaml
  oc apply -f crd-https.yaml
else
  oc apply -f kbs-config.yaml
  oc apply -f crd.yaml
fi


wait_for_deployment kbs-deployment kbs-operator-system || exit 1
