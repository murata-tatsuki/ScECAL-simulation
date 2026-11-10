#!/usr/bin/env bash
# Source this file before building or running CEPCScECAL on this server.
export CEPCSC_ECAL_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

_cepcsc_ecal_setup() {
    local stack_setup=/cvmfs/sw.hsf.org/key4hep/releases/2025-05-29/x86_64-almalinux9-gcc14.2.0-opt/key4hep-stack/2025-05-30-4x4qya/setup.sh
    local had_nounset=0
    if [[ ${KEY4HEP_STACK:-} != "$stack_setup" ]]; then
        if [[ ! -r "$stack_setup" ]]; then
            echo "Key4hep setup is not readable: $stack_setup" >&2
            return 1
        fi
        # The upstream setup expands optional, unset environment variables.
        [[ $- == *u* ]] && had_nounset=1
        set +u
        if ! source "$stack_setup"; then
            (( had_nounset )) && set -u
            return 1
        fi
        (( had_nounset )) && set -u
    fi

    local geant_prefix gcc_runtime
    geant_prefix="$(geant4-config --prefix)" || return 1
    gcc_runtime="$("${CXX:-c++}" -print-file-name=libstdc++.so.6)" || return 1
    if [[ ! -f "$gcc_runtime" ]]; then
        echo "GCC runtime was not found: $gcc_runtime" >&2
        return 1
    fi
    export Geant4_DIR="$geant_prefix/lib/cmake/Geant4"
    export ROOT_DIR="$(root-config --prefix)/cmake"
    # Prefer the compiler runtime and Geant4 libraries used for this build.
    export LD_LIBRARY_PATH="$(dirname -- "$gcc_runtime"):$geant_prefix/lib:$(root-config --libdir)${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
}

if _cepcsc_ecal_setup; then
    unset -f _cepcsc_ecal_setup
else
    unset -f _cepcsc_ecal_setup
    return 1 2>/dev/null || exit 1
fi
