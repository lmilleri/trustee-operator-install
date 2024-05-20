#!/bin/bash

source ./common.sh

# Check if oc command is available
check_oc

# Apply the operator manifests
apply_operator_manifests

wait_for_deployment kbs-operator-controller-manager kbs-operator-system || exit 1
