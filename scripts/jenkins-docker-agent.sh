#! /bin/bash

docker rm -f e2e-agent
docker volume create jenkins_home
docker run -d --restart always \
--init \
-u root \
--name e2e-agent \
-v /usr/bin/docker:/usrbin/docker:ro \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
-v jenkins_home:/home/jenkins \
-v jenkins_Home:/var/lib/jenkins \
-e JENKINS_AGENT_NAME=e2e-agent \
-e JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
-e JENKINS_URL=http://192.168.100.100:8080 \
-e JENKINS_SECRET=825a156c493e8a465a672c044bede1f6beeb5c2b2db13c9e6adffc52ee684744 \
-e JENKINS_WEB_SOCKET=true \
jenkins/inbound-agent
