export PODMAN_MACHINE_NAME="podman-machine-default"

podman machine init && podman machine start ${PODMAN_MACHINE_NAME}

PODMAN_MACHINE_STATUS=$(podman machine inspect ${PODMAN_MACHINE_NAME} | jq -r '.[].State')
while [[ "${PODMAN_MACHINE_STATUS}" != "running" ]]; do
    echo "[Info] Waiting for podman machine '${PODMAN_MACHINE_NAME}' to be running, current status: ${PODMAN_MACHINE_STATUS}..."
    sleep 1
    PODMAN_MACHINE_STATUS=$(podman machine inspect ${PODMAN_MACHINE_NAME} | jq -r '.[].State')
done

podman machine ssh "${PODMAN_MACHINE_NAME}" 'sudo rpm-ostree install qemu-user-static'

podman machine stop ${PODMAN_MACHINE_NAME} && podman machine start ${PODMAN_MACHINE_NAME}

