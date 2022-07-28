
FROM jenkins/inbound-agent:alpine as jnlp

FROM 20.10.17-dind-alpine3.16

RUN apk add --no-cache aws-cli

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
