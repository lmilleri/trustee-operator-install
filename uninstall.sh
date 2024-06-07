#!/bin/bash

CLUSTER="${CLUSTER:-k8s}"

oc delete sub -n kbs-operator-system kbs-operator-system
oc delete og kbs-operator-system
oc delete ns kbs-operator-system
if [[ $CLUSTER == "k8s" ]] then
  oc delete catalogsource -n olm trustee-operator-catalog
else
  oc delete catalogsource -n openshift-marketplace trustee-operator-catalog
fi
