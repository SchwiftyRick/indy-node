#!/bin/bash -xe

INPUT_PATH="$1"
VERSION="$2"
OUTPUT_PATH="${3:-.}"
PACKAGE_VERSION=${4:-$VERSION}

PACKAGE_NAME=indy-node

# copy the sources to a temporary folder
TMP_DIR="$(mktemp -d)"
cp -r "${INPUT_PATH}/." "${TMP_DIR}"

# prepare the sources
cd "${TMP_DIR}/build-scripts/ubuntu-2004"
./prepare-package.sh "${TMP_DIR}" "${VERSION}"

sed -i "s/{package_name}/${PACKAGE_NAME}/" "prerm"

cd "${TMP_DIR}"

fpm --input-type "python" \
    --output-type "deb" \
    --architecture "amd64" \
    --verbose \
    --python-package-name-prefix "python3" \
    --python-bin "/usr/bin/python3" \
    --exclude "*.pyc" \
    --exclude "*.pyo" \
    --depends at \
    --depends iptables \
    --depends libsodium23 \
    --no-python-fix-dependencies \
    --maintainer "Hyperledger <hyperledger-indy@lists.hyperledger.org>" \
    --before-install "${TMP_DIR}/build-scripts/ubuntu-2004/preinst_node" \
    --after-install "${TMP_DIR}/build-scripts/ubuntu-2004/postinst_node" \
    --before-remove "${TMP_DIR}/build-scripts/ubuntu-2004/prerm" \
    --name "${PACKAGE_NAME}" \
    --version ${PACKAGE_VERSION} \
    --package "${OUTPUT_PATH}" \
    "${TMP_DIR}"

    # --python-pip "$(which pip)" \
        # ERROR:  download_if_necessary': Unexpected directory layout after easy_install. Maybe file a bug? The directory is /tmp/package-python-build-c42d23109dcca1e98d9f430a04fe79a815f10d8ed7a719633aa969424f94 (RuntimeError)

rm -rf "${TMP_DIR}"
