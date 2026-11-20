#!/usr/bin/env bash
# Build a device app and package it for later signing. Does not change OS targets.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
if [ "$(uname -s)" != Darwin ]; then
  echo "This build needs macOS and Xcode; run the Device IPA GitHub workflow." >&2
  exit 1
fi
for tool in xcodebuild xcodegen python3 ditto; do
  command -v "$tool" >/dev/null || { echo "Missing build tool: $tool" >&2; exit 1; }
done
# GitHub's checkout preserves the executable bits on upstream scripts.
[ -d vendor/nodejs-mobile/rooted ] || scripts/fetch-nodejs-mobile.sh
[ -d vendor/python/rooted ] || scripts/fetch-python.sh
scripts/check-root-imports.sh
[ -d vendor/libgit2/Libgit2.xcframework ] || scripts/build-libgit2.sh
[ -d vendor/ffmpeg/FFmpeg.xcframework ] || scripts/fetch-ffmpeg.sh
scripts/build-engine.sh
(cd app && xcodegen generate --quiet)
mkdir -p build/ipa
# A destination, rather than -sdk iphoneos, lets the embedded watch target
# select its own SDK. Preserve the app, share and widget targets unchanged.
xcodebuild -project app/DshIOS.xcodeproj -scheme DshIOS \
  -configuration Release -destination 'generic/platform=iOS' \
  -derivedDataPath "$root/build/DeviceDerivedData" \
  -skipPackagePluginValidation CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  build 2>&1 | tee build/ipa/xcodebuild.log
app="$root/build/DeviceDerivedData/Build/Products/Release-iphoneos/DshIOS.app"
[ -d "$app" ] || { echo "Device app not produced: $app" >&2; exit 1; }
# Stage in a fresh directory, so repeated runs cannot include stale bundles.
stage="$(mktemp -d "$root/build/ipa/stage.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/Payload"
ditto "$app" "$stage/Payload/DshIOS.app"
export FISH_IPA_APP="$stage/Payload/DshIOS.app"
export FISH_IPA_MANIFEST="$root/build/ipa/build-manifest.json"
python3 - <<'PY'
import json, os, pathlib, plistlib, subprocess
app = pathlib.Path(os.environ['FISH_IPA_APP'])
def info(path):
    with path.open('rb') as stream:
        p = plistlib.load(stream)
    return {
        'bundle': str(path.parent.relative_to(app.parent)),
        'bundle_id': p.get('CFBundleIdentifier'),
        'minimum_os': p.get('MinimumOSVersion'),
        'platforms': p.get('CFBundleSupportedPlatforms', []),
        'version': p.get('CFBundleShortVersionString'),
        'build': p.get('CFBundleVersion'),
    }
manifest = {
    'source_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], text=True).strip(),
    'signing': 'unsigned; embedded frameworks may carry ad-hoc signatures',
    'ios_16_6_1_tested': False,
    'main_app': info(app / 'Info.plist'),
    'embedded_bundles': [info(p) for p in sorted(app.rglob('Info.plist')) if p != app / 'Info.plist'],
}
if 'iPhoneOS' not in manifest['main_app']['platforms']:
    raise SystemExit('Refusing to package a non-device app')
pathlib.Path(os.environ['FISH_IPA_MANIFEST']).write_text(
    json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Actual app MinimumOSVersion:', manifest['main_app']['minimum_os'])
print('Unsigned package; iOS 16.6.1 compatibility has NOT been verified.')
PY
out="$root/build/ipa/FishPocket-unsigned.ipa"
ditto -c -k --keepParent "$stage/Payload" "$out"
shasum -a 256 "$out" > "$out.sha256"
echo "Packaged unsigned device app: $out"
