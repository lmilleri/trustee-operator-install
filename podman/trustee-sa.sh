openssl genpkey -algorithm ed25519 > privateKey
openssl pkey -in privateKey -pubout -out publicKey

echo "Hello podman!" > secret

podman run -it \
-v ./kbs-config.json:/etc/kbs-config/kbs-config.json:Z,U \
-v ./publicKey:/etc/auth-secret/publicKey:Z,U \
-v ./reference-values.json:/opt/confidential-containers/rvps/reference-values/reference-values.json:Z,U \
-v ./policy.rego:/opt/confidential-containers/opa/policy.rego:Z,U \
-v ./secret:/opt/confidential-containers/kbs/repository/default/secrets/secret:Z,U \
-p 8080:8080 \
--rm \
quay.io/openshift_sandboxed_containers/kbs:latest /usr/local/bin/kbs --config-file /etc/kbs-config/kbs-config.json
