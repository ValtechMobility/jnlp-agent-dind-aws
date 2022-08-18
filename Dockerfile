FROM jenkins/inbound-agent:alpine as jnlp

FROM docker:20.10.17-dind-alpine3.16

RUN apk add --no-cache openjdk11-jre git curl bash aws-cli
RUN curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
RUN ln -s /usr/local/bin/helm /usr/local/bin/helm3

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
