oc delete kbsconfig kbsconfig-sample
oc delete cm rvps-reference-values-sample rvps-reference-values rvps-config-grpc-sample kbs-config-grpc-sample as-config-grpc-sample \
             as-config-grpc kbs-config-grpc rvps-config-grpc 
oc delete secret kbs-auth-public-key kbsres1
oc delete secret kbs-https-certificate kbs-https-key
