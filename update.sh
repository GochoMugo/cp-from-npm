#!/usr/bin/env bash
DEPS="node npm rsync"
WDIR="/tmp/cp-from-npm/"
MANIFEST_TEMPLATE='{ "private": true, "name": "cp-npm-github" }'
SANITIZE_PROG="$(cat <<EOF
const fs = require("fs");
const filepath = process.argv[2];
const pkg = require(filepath);
const output = {};
for (const key in pkg) {
    if (key[0] === "_") continue;
    output[key] = pkg[key];
}
fs.writeFileSync(filepath, JSON.stringify(output, null, 2));
EOF
)"

create_wdir() {
    if [[ -d "${WDIR}" ]] ; then
        return
    fi
    mkdir -p "${WDIR}"
    echo "${MANIFEST_TEMPLATE}" > "${WDIR}/package.json"
    echo "${SANITIZE_PROG}" > "${WDIR}/sanitize.js"
}


run() {
    set -e              # Reverse any change made!
    GLOBIGNORE=".:.."   # Reverse any change made!

    local usage="usage: update.sh <name> <destdir>"
    local pkg_name="${1}"
    if [[ -z "${pkg_name}" ]] ; then
        echo "error: <name> missing (${usage})"
        exit 1
    fi
    local destdir="${2}"
    if [[ -z "${destdir}" ]] ; then
        echo "error: <destdir> missing (${usage})"
        exit 1
    fi
    destdir="$(readlink -f "${destdir}")"

    create_wdir
    pushd "${WDIR}" > /dev/null
    npm install --ignore-scripts --no-save --no-package-lock "${pkg_name}"
    rsync \
        --archive \
        --delete \
        --exclude=node_modules \
        --force \
        "node_modules/${pkg_name}"/* "${destdir}"
    sanitize "${destdir}/package.json"
    popd > /dev/null
}


sanitize() {
    local manifest_path="${1}" # Assert.ok!
    node "${WDIR}/sanitize.js" "${manifest_path}"
}
