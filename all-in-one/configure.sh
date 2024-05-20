#!/bin/bash

source ../common.sh

# create keys
openssl genpkey -algorithm ed25519 > privateKey
openssl pkey -in privateKey -pubout -out publicKey
oc create secret generic kbs-auth-public-key --from-file=publicKey -n kbs-operator-system

oc apply -f kbs-config.yaml

oc apply -f reference-values.yaml

oc create secret generic kbsres1 --from-literal key1=res1val1 --from-literal key2=res1val2 -n kbs-operator-system

oc apply -f crd.yaml

wait_for_deployment kbs-deployment kbs-operator-system || exit 1
