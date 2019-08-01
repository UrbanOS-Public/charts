how do we deploy / test this with minikube
how do we reference each required chart in our own repo? Is it enough to just match the names?
Can we have the master chart without it's own image? What does it actually need?
What happens for dependencies of dependencies?
How do we run an unpublished/local chart on minikube?

kafka
- resource limits: what can we scale down
- Are we using the kafka topics in the values file?
- make kafka/strimzi optional

Get LDAP connection working



andi 
- connect to ldap

reaper
- aws creds

discovery-streams
- smoke test


alias hd='helm delete --purge master'
alias hu='helm dep update master'
alias hs='helm upgrade --install master master/'
alias hw='watch kubectl get po'


- (install minikube)
minikube start
helm init --upgrade
rm -rf master/charts/
helm dep update master/
helm repo add scdp https://smartcitiesdata.github.io/charts
helm delete --purge master
helm upgrade --install master master/

helm delete --purge master; helm upgrade --install master ./master/

k get po --all-namespaces

kubectl create secret generic ldap --from-literal=host=localhost

k apply -f ./templates/secrets/ldap.yaml 
 k describe secret/ldap
