#!/usr/bin/env bash
# Print the UDID of a bootable iPhone simulator whose iOS runtime is actually
# installed. A device's `isAvailable` can be true even when its runtime is not
# installed, so binding the device to a present runtime is what makes the
# xcodebuild `-destination id=...` reliable across runner images.
#
# Exits non-zero (and dumps the inventory) if no usable device is found.
set -euo pipefail

UDID=$(xcrun simctl list devices available --json | python3 -c '
import json, sys
devices = json.load(sys.stdin)["devices"]
# Runtimes that appear as keys with device entries are installed & usable.
ios_runtimes = sorted(rt for rt in devices if "iOS" in rt and devices[rt])
iphones = [d for rt in ios_runtimes for d in devices[rt] if "iPhone" in d["name"]]
print(iphones[-1]["udid"] if iphones else "")
')

if [ -z "$UDID" ]; then
  echo "No iPhone simulator with an installed iOS runtime. Inventory:" >&2
  xcrun simctl list runtimes >&2
  xcrun simctl list devices available >&2
  exit 1
fi

echo "$UDID"
