#Pre Reqs
`helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator --version 0.13.0`
# Required Parameters
kubernetes-data-platform.global.objectStore.bucketName=<S3 BUCKET NAME HERE>
kubernetes-data-platform.global.objectStore.accessKey=<S3 BUCKET ACCESS KEY HERE> 
kubernetes-data-platform.global.objectStoreacessSecret=<S3 BUCKET SECRET HERE> 
kubernetes-data-platform.postgres.service.externalAddress=<POSTGRES DB LOCATION HERE > 
kubernetes-data-platform.postgres.db.user=<POSTGRED DB USER HERE>
kubernetes-data-platform.postgres.enable=<SPIN UP POSTGRES POD?>
kubernetes-data-platform.postgres.db.password=<POSTGRES DB PASSWORD HERE>
kubernetes-data-platform.kdp.s3.hostedFileBucket=<BUCKET NAME HERE>
discovery-api.postgres.host=<HOST HERE>
discovery-api.s3.hostedFileBucket=<HOST HERE>
openldap.adminPassword=admin