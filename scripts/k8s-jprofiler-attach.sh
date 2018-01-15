#!/bin/bash
# https://gist.github.com/smola/2fe28e9bf64ad0144f53f4e9473bfb3c?permalink_comment_id=3389983
set -e

if [[ -z ${K8S_JVM_POD} ]]; then
    echo "K8S_JVM_POD not defined"
    exit 1
fi

EXEC="kubectl exec ${K8S_JVM_POD}"
CP="kubectl cp ${K8S_JVM_POD}"

if [[ -z ${K8S_JVM_PID} ]]; then
    echo "K8S_JVM_PID not defined, pick one:"
    ${EXEC} jps 2>/dev/null
    exit 1
fi

JPROFILER_PACKAGE=jprofiler_linux_10_1.tar.gz
JPROFILER_PACKAGE_URL=https://download-keycdn.ej-technologies.com/jprofiler/${JPROFILER_PACKAGE}

if [[ ! -f ${JPROFILER_PACKAGE} ]]; then
    wget -O "${JPROFILER_PACKAGE}" "${JPROFILER_PACKAGE_URL}"
fi

if ! ${EXEC} -- find /root/${JPROFILER_PACKAGE} &>/dev/null; then
    echo "${JPROFILER_PACKAGE} not found on the server, copying..."
    kubectl cp "${JPROFILER_PACKAGE}" "${K8S_JVM_POD}:/root/${JPROFILER_PACKAGE}"
else
    echo "${JPROFILER_PACKAGE}  already found in the server"
fi

JPROFILER_PORT=31757

${EXEC} -- tar -C /root -xf "/root/${JPROFILER_PACKAGE}"

${EXEC} -- /root/jprofiler10.1/bin/jpenable --pid=${K8S_JVM_PID} --port=${JPROFILER_PORT} --noinput --gui
