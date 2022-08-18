FROM jenkins/inbound-agent:alpine as jnlp

FROM docker:20.10.17-dind-alpine3.16

RUN apk add --no-cache openjdk11-jre git curl bash aws-cli
RUN apk add helm --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
