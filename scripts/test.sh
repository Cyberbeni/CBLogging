#!/bin/bash

set -eo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

DOCKER_IMAGE="docker.io/cyberbeni/swift-builder:latest"
PROCESS="swift"

do_it() {
	RUN_TEST="swift test --only-use-versions-from-resolved-file"
	$RUN_TEST --traits LocalizedTimestamp
	$RUN_TEST --disable-default-traits
}

source scripts/_script-wrapper.sh
