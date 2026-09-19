#!/usr/bin/env bash
#
# Runs the BACKit test suite.
#
# On a Mac with Xcode this is just `swift test` and the script adds nothing but
# a stable scratch path. Its real purpose is the other case: an assistant
# session working in a Linux sandbox, where there is no toolchain at all. There
# it downloads a Swift release into /tmp and runs the same tests, which is what
# makes "did I break the model?" answerable without a round trip.
#
# BACKit only: it imports Foundation and nothing else, so it builds anywhere.
# The app target needs SwiftUI and SwiftData and can only be built by Xcode.
#
#   ./Reference/run_tests.sh                     run everything
#   ./Reference/run_tests.sh --filter DrinkingPace   one test type
#
# --filter matches the test TYPE name (DrinkingPaceTests), not the display
# name in @Suite("Drinking pace").
#
set -euo pipefail

SWIFT_VERSION="6.1.2"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRATCH="${TMPDIR:-/tmp}/backit-build"

find_or_install_swift() {
    if command -v swift >/dev/null 2>&1; then
        return
    fi

    if [[ "$(uname -s)" != "Linux" ]]; then
        echo "No swift on PATH. On a Mac, install Xcode or the command line tools." >&2
        exit 1
    fi

    # Ubuntu only; that is what these sandboxes run.
    local arch suffix dir
    arch="$(uname -m)"
    case "$arch" in
        aarch64) suffix="-aarch64" ;;
        x86_64)  suffix="" ;;
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac

    dir="/tmp/swift/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04${suffix}"
    if [[ ! -x "$dir/usr/bin/swift" ]]; then
        echo "Downloading Swift ${SWIFT_VERSION} (about 800 MB, once per session)..." >&2
        mkdir -p /tmp/swift
        curl -sL -o /tmp/swift/toolchain.tar.gz \
            "https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2204${suffix}/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04${suffix}.tar.gz"
        tar xzf /tmp/swift/toolchain.tar.gz -C /tmp/swift
        rm /tmp/swift/toolchain.tar.gz
    fi
    export PATH="$dir/usr/bin:$PATH"
}

find_or_install_swift
swift --version

# The scratch path keeps .build out of the repository.
exec swift test --package-path "$ROOT/BACKit" --scratch-path "$SCRATCH" "$@"
