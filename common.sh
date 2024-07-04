#!/bin/bash

# Function to check if the oc command is available
function check_oc() {
    if ! command -v oc &>/dev/null; then
        echo "oc command not found. Please install the oc CLI tool."
        exit 1
    fi
}

# Function to wait for the operator deployment object to be ready
function wait_for_deployment() {
    local deployment=$1
    local namespace=$2
    local timeout=300
    local interval=5
    local elapsed=0
    local ready=0

    while [ $elapsed -lt $timeout ]; do
        ready=$(oc get deployment -n "$namespace" "$deployment" -o jsonpath='{.status.readyReplicas}')
        if [ "$ready" == "1" ]; then
            echo "Operator $deployment is ready"
            return 0
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
    done
    echo "Operator $deployment is not ready after $timeout seconds"
    return 1
}

# Function to apply the operator manifests
function apply_operator_manifests() {
    
    # Apply the manifests, error exit if any of them fail
    oc apply -f ns.yaml || exit 1
    if [[ $CLUSTER == "k8s" ]] then
      if [[ $MICRO == "yes" ]] then
        oc apply -f kbs_catalog-micro.yaml || exit 1
      else
        oc apply -f kbs_catalog-lmilleri.yaml || exit 1
        #oc apply -f kbs_catalog.yaml || exit 1
      fi
    else
      if [[ $MICRO == "yes" ]] then
        oc apply -f kbs_catalog-ocp-micro.yaml || exit 1
      else
        oc apply -f kbs_catalog-ocp-lmilleri.yaml || exit 1
        #oc apply -f kbs_catalog-ocp.yaml || exit 1
      fi
    fi
    oc apply -f og.yaml || exit 1
    if [[ $CLUSTER == "k8s" ]] then
      oc apply -f subs.yaml || exit 1
    else
      oc apply -f subs-ocp.yaml || exit 1
    fi
}
