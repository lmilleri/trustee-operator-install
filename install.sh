#!/bin/bash

CLUSTER="${CLUSTER:-k8s}"
MICRO="${MICRO:-no}"

source ./common.sh

# Check if oc command is available
check_oc

# Apply the operator manifests
apply_operator_manifests $CLUSTER $MICRO

wait_for_deployment trustee-operator-controller-manager kbs-operator-system || exit 1
