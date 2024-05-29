POD_NAME=$(oc get pods -l app=kbs -o jsonpath='{.items[0].metadata.name}' -n kbs-operator-system)
oc exec -n kbs-operator-system -it $POD_NAME -c kbs -- sed -i 's/false/true/g' /opt/confidential-containers/opa/policy.rego

oc cp privateKey kbs-client:/
echo "Hello!" > my-secret
oc cp my-secret kbs-client:/
oc cp https.crt kbs-client:/

oc exec -it kbs-client -- kbs-client --cert-file https.crt --url https://kbs-service:8080 config --auth-private-key privateKey set-resource --resource-file my-secret --path default/test/mysecret
oc exec -it kbs-client -- kbs-client --cert-file https.crt --url https://kbs-service:8080 get-resource --path default/test/mysecret
oc exec -it kbs-client -- kbs-client --cert-file https.crt --url https://kbs-service:8080 get-resource --path default/kbsres1/key1
oc exec -it kbs-client -- kbs-client --cert-file https.crt --url https://kbs-service:8080 get-resource --path default/kbsres1/key2
rm my-secret
