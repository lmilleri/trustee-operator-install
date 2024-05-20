# Build Trustee catalog
Instruction for building the trustee catalog and push it to your registry

## setup registry
For example:
`export REGISTRY=quay.io/rh_ee_lmilleri`

## customize images
Change dir to your trustee-operator local repo:
`cd <trustee-operator-project-dir>`

### Trustee image
If you need to specify your own trustee image, just change the `KBS_IMAGE_NAME` in `bundle/manifests/kbs-operator.clusterserviceversion.yaml`.
For example, `KBS_IMAGE_NAME: quay.io/openshift_sandboxed_containers/kbs:latest` for a all-in-one image deployment

### trustee-operator image
If you need to customize the trustee-operator image, just change the `image` in `bundle/manifests/kbs-operator.clusterserviceversion.yaml`.
For example: `image: quay.io/rh_ee_lmilleri/kbs-operator:latest`

## build images and push to registry
`make docker-build docker-push IMG=${REGISTRY}/kbs-operator:latest`
`VERSION=0.0.1 IMG=$REGISTRY/kbs-operator:latest IMAGE_TAG_BASE=$REGISTRY/kbs-operator make bundle-build bundle-push catalog-build catalog-push`
