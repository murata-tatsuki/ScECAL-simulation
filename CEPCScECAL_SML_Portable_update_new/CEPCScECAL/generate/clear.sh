#!/bin/bash
path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
find "$path/cmd/" -name "*.cmd" -delete
find "$path/err/" -name "*.err" -delete
find "$path/log/" -name "*.log" -delete
find "$path/mac/" -name "*.mac" -delete
find "$path/out/" -name "*.out" -delete
find "$path/run/" -name "*.sh" -delete
# Historical ROOT cleanup disabled: its original directory was not copied to this server.
find "$path/temp/" -name "*.sh" -delete
find "$path/log/" -name "*.log" -delete

