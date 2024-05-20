oc delete sub -n kbs-operator-system kbs-operator-system
oc delete og kbs-operator-system
oc delete ns kbs-operator-system

# uncomment it for OCP (and comment the line below)
# oc delete catalogsource -n openshift-marketplace kbs-operator-catalog
oc delete catalogsource -n olm kbs-operator-catalog
