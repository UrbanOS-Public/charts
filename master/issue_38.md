kafka
- resource limits: what can we scale down
- Are we using the kafka topics in the values file?
- make kafka/strimzi optional



discovery-streams
- smoke test


alias hd='helm delete --purge master'
alias hu='helm dep update master'
alias hs='helm upgrade --install master master/'
alias hw='watch kubectl get po'
alias po='kubectl get po'

Elsa.list_topics(["streaming-service-kafka-bootstrap": 9092])