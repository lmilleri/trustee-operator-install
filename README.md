# Deploy the operator in Kubernetes/OpenShift

Note: For vanilla Kubernetes cluster, you'll need to make
the following changes

- Install [Operator Lifecycle Manager](https://operatorhub.io/how-to-install-an-operator)
- Change the `oc` command to `kubectl` or create a temporary alias

You can run `install.sh` which will deploy the operator
or you can run the following commands individually

Note: check the `kbs_catalog.yaml` and `subs.yaml` for installing the operator in k8s or ocp (default settings for k8s)

```
oc apply -f kbs_catalog.yaml
oc apply -f ns.yaml
oc apply -f og.yaml
oc apply -f subs.yaml
```

Check for operator controller manager in `kbs-operator-system` namespace
kbsclient-sim.yaml
# Add trustee configuration

For all-in-one deployment:
`cd all-in-one`
For microservices deployment:
`cd microservices`

Then type:
`./configure.sh`kbsclient-sim.yaml

The above command will create the key pair and configure trustee.

### Enable permissive resource policy [Optional]

For testing with sample attester, you will have to do this:

Get the KBS deployment pod name
```
POD_NAME=$(oc get pods -l app=kbs -o jsonpath='{.items[0].metadata.name}' -n kbs-operator-system)
```kbsclient-sim.yaml

Allow all access to resources
```
oc exec -n kbs-operator-system -it "$POD_NAME" -c kbs  -- sed -i 's/false/true/g' /opt/confidential-containers/opa/policy.rego
```

Likewise you can enable permissive policy for Attestation Service (AS) for testing
```
oc exec -n kbs-operator-system -it "$POD_NAME" -c as  -- sed -i 's/false/true/g' /opt/confidential-containers/attestation-service/opa/default.rego
```

### Deploy sample kbs_client

Deploy the sample KBS client. This doesn't use any real TEE.

```
oc apply -f kbsclient-sim.yaml

```

### Run tests
From inside the all-in-one or microservices dir, you can run some basic tests with the command:
`./test.sh`

### Get secret resource from Trustee

Get the KBS service IP
```
KBS_SVC_IP=$(oc get svc -n kbs-operator-system kbs-service -o jsonpath={.spec.clusterIP})
echo ${KBS_SVC_IP}
```

Retrieve the secret resource
```
oc exec -it kbs-client -- kbs-client --url http://"REPLACE_WITH_THE_VALUE_OF_KBS_SVC_IP":8080 get-resource --path default/kbsres1/key1
```

You can check the KBS and AS logs as well

```
# KBS logs
oc logs -n kbs-operator-system deploy/kbs-deployment -c kbs

# AS logs
oc logs -n kbs-operator-system deploy/kbs-deployment -c as
```

