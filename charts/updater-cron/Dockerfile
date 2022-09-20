FROM ubuntu:latest

ENV PATH="${PATH}:~/.local/bin"

#Install curl and jq
RUN apt-get update && apt-get install -y curl jq

#Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" && \
    chmod +x kubectl && \
    mv ./kubectl /usr/local/bin && \
    echo $(kubectl version --client)
