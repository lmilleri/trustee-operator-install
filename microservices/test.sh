oc cp privateKey kbs-client:/
echo "Hello!" > my-secret
oc cp my-secret kbs-client:/
oc exec -it kbs-client -- kbs-client --url http://kbs-service:8080 config --auth-private-key privateKey set-resource --resource-file my-secret --path default/test/mysecret
oc exec -it kbs-client -- kbs-client --url http://kbs-service:8080 get-resource --path default/test/mysecret
oc exec -it kbs-client -- kbs-client --url http://kbs-service:8080 get-resource --path default/kbsres1/key1
oc exec -it kbs-client -- kbs-client --url http://kbs-service:8080 get-resource --path default/kbsres1/key2
rm my-secret
