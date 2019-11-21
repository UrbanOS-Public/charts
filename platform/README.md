# Pre Reqs
`helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator --version 0.13.0`

# Required Parameters
kubernetes-data-platform.global.objectStore.bucketName=<S3 BUCKET NAME HERE>
kubernetes-data-platform.global.objectStore.accessKey=<S3 BUCKET ACCESS KEY HERE>
kubernetes-data-platform.global.objectStore.accessSecret=<S3 BUCKET SECRET HERE>
kubernetes-data-platform.postgres.service.externalAddress=<POSTGRES DB LOCATION HERE >
kubernetes-data-platform.postgres.db.user=<POSTGRES DB USER HERE>
kubernetes-data-platform.postgres.enable=<SPIN UP POSTGRES POD?>
kubernetes-data-platform.postgres.db.password=<POSTGRES DB PASSWORD HERE>
kubernetes-data-platform.kdp.s3.hostedFileBucket=<BUCKET NAME HERE>
discovery-api.postgres.host=<HOST HERE>
discovery-api.s3.hostedFileBucket=<HOST HERE>
openldap.adminPassword=admin

# To make changes to a dependent chart for development
1. Make the changes you need on your local chart
2. Navigate to the `docs/` directory and run `helm serve` and note the service address
3. Open `requirements.yaml`
4. Find the desired chart and change the value of `repository:` to `https://<SERVICE ADDRESS>`

# Running in Azure Example
`helm add repo https://smartcitiesdata.github.io/charts`
```
helm upgrade --install platform scdp/platform \
 --set kubernetes-data-platform.enabled=true \
 --set kubernetes-data-platform.minio.gateway.enable=true \
 --set kubernetes-data-platform.minio.gateway.type=azure \
 --set kubernetes-data-platform.global.environment=demo \
 --set kubernetes-data-platform.global.objectStore.accessKey='<STORAGE ACCOUNT NAME>' \
 --set kubernetes-data-platform.global.objectStore.bucketName='<CONTAINER NAME>' \
 --set kubernetes-data-platform.global.objectStore.accessSecret='<STORAGE ACCOUNT ACCESS KEY>' \
 --set kubernetes-data-platform.postgres.service.externalAddress=<DB SERVER NAME ex: scosdev.postgres.database.azure.com> \
 --set kubernetes-data-platform.postgres.db.user=<DB USERNAME> \
 --set kubernetes-data-platform.postgres.db.name=<DB NAME> \
 --set kubernetes-data-platform.postgres.db.password=<DB PASSWORD> \
 --set kubernetes-data-platform.postgres.enable=false \
 --set discovery-api.postgres.host=<DB SERVER NAME same as above> \
 --set discovery-api.postgres.dbname=metastore \
 --set discovery-api.postgres.user=<DB USERNAME> \
 --set discovery-api.postgres.password=<DB PASSWORD> \
 --set discovery-api.redis.host=<REDIS_HOST>\
 --set discovery-api.redis.password=<REDIS_PASSWORD>\
 --set reaper.redis.host=<REDIS_HOST>\
 --set reaper.redis.password=<REDIS_PASSWORD>\
 --set valkyrie.redis.host=<REDIS_HOST>\
 --set valkyrie.redis.password=<REDIS_PASSWORD>\
 --set forklift.redis.host=<REDIS_HOST>\
 --set forklift.redis.password=<REDIS_PASSWORD>\
 --set andi.redis.host=<REDIS_HOST>\
 --set andi.redis.password=<REDIS_PASSWORD>\
 --set openldap.adminPassword=admin \
 --set forklift.postgres.host=<DB SERVER NAME same as above> \
 --set discovery-api.s3.hostedFileBucket=hosted-bucket \
 --set flair.enabled=false \
 --set odo.enabled=false
 ```
