#!/usr/bin/env bash

set -e
set -x

OUTPUT_PATH="${1:-.}"

function build_from_pypi {
    PACKAGE_NAME="$1"

    if [ -z "$2" ]; then
        PACKAGE_VERSION=""
    else
        PACKAGE_VERSION="==$2"
    fi
    POSTINST_TMP="postinst-${PACKAGE_NAME}"
    PREREM_TMP="prerm-${PACKAGE_NAME}"
    cp postinst "${POSTINST_TMP}"
    cp prerm "${PREREM_TMP}"
    sed -i "s/{package_name}/python3-${PACKAGE_NAME}/" "${POSTINST_TMP}"
    sed -i "s/{package_name}/python3-${PACKAGE_NAME}/" "${PREREM_TMP}"

    fpm --input-type "python" \
        --output-type "deb" \
        --architecture "amd64" \
        --verbose \
        --python-package-name-prefix "python3" \
        --python-bin "/usr/bin/python3" \
        --exclude "*.pyc" \
        --exclude "*.pyo" \
        --maintainer "Hyperledger <hyperledger-indy@lists.hyperledger.org>" \
        --after-install "${POSTINST_TMP}" \
        --before-remove "${PREREM_TMP}" \
        --package "${OUTPUT_PATH}" \
        "${PACKAGE_NAME}${PACKAGE_VERSION}"

        # --python-pip "$(which pip)" \
        # ERROR:  download_if_necessary': Unexpected directory layout after easy_install. Maybe file a bug? The directory is /tmp/package-python-build-c42d23109dcca1e98d9f430a04fe79a815f10d8ed7a719633aa969424f94 (RuntimeError)
        

    rm "${POSTINST_TMP}"
    rm "${PREREM_TMP}"
}

# build 3rd parties:
#   build_from_pypi <pypi-name> <version>
# TODO duplicates list from Jenkinsfile.cd
build_from_pypi timeout-decorator 0.5.0
build_from_pypi distro 1.5.0

