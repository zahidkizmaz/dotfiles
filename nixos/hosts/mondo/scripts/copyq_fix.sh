#!/usr/bin/env bash

set -eo pipefail

if [[ $(uname -m) == 'arm64' ]]; then
  xattr -rd com.apple.quarantine /Applications/CopyQ.app
  codesign -f --deep -s - /Applications/CopyQ.app
else
  echo "SKIPPING: Not ARM machine"
fi
