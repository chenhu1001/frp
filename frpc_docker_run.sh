#!/usr/bin/env bash
set -euo pipefail

FRPC_CONFIG=${1:-/opt/frpc/frpc.toml}
FRPC_IMAGE=${FRPC_IMAGE:-snowdreamtech/frpc}
FRPC_CONTAINER=${FRPC_CONTAINER:-frpc}

if [ ! -f "${FRPC_CONFIG}" ]; then
    echo "frpc config not found: ${FRPC_CONFIG}" >&2
    echo "Usage: $0 [frpc.toml path]" >&2
    exit 1
fi

sudo docker rm -f "${FRPC_CONTAINER}" 2>/dev/null || true
sudo docker run -d \
    --name "${FRPC_CONTAINER}" \
    --restart always \
    --network host \
    --entrypoint /usr/bin/frpc \
    -v "${FRPC_CONFIG}:/frp/frpc.toml:ro" \
    "${FRPC_IMAGE}" \
    -c /frp/frpc.toml
