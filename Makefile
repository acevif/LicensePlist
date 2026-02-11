PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_licenseplist

VERSION_STRING=$(shell ./Tools/get-version)
LICENSE_PATH="$(shell pwd)/LICENSE"

ARTIFACT_BUNDLE_PATH=$(TEMPORARY_FOLDER)/LicensePlistBinary.artifactbundle

clean:
	rm -rf "$(TEMPORARY_FOLDER)"
	swift package clean

build: clean
	swift build --disable-sandbox -c release

build_portable: clean
	swift build --disable-sandbox -c release --arch x86_64 --arch arm64

test:
	swift test

lint:
	swiftlint

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/license-plist" "$(PREFIX)/bin/license-plist"

portable_zip: build_portable
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f ".build/apple/Products/Release/license-plist" "$(TEMPORARY_FOLDER)/license-plist"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd $(TEMPORARY_FOLDER); zip -r - LICENSE license-plist) > "./portable_licenseplist.zip"
	rm -r "$(TEMPORARY_FOLDER)"

spm_artifactbundle_macos: build_portable
	mkdir -p "$(ARTIFACT_BUNDLE_PATH)/license-plist-$(VERSION_STRING)-macos/bin"
	sed 's/__VERSION__/$(VERSION_STRING)/g' Tools/info-macos.json.template > "$(ARTIFACT_BUNDLE_PATH)/info.json"
	cp -f ".build/apple/Products/Release/license-plist" "$(ARTIFACT_BUNDLE_PATH)/license-plist-$(VERSION_STRING)-macos/bin"
	cp -f "$(LICENSE_PATH)" "$(ARTIFACT_BUNDLE_PATH)"
	(cd "$(TEMPORARY_FOLDER)"; zip -yr - "LicensePlistBinary.artifactbundle") > "./LicensePlistBinary-macos.artifactbundle.zip"

# Note: `nix build` runs in a read-only, network-restricted sandbox, so it
# cannot update generated nix files nor fetch hashes. Run this first.
# Inputs: .build/workspace-state.json
# Outputs: nix/workspace-state.json, nix/default.nix
nix_update:
	@test -f .build/workspace-state.json || (echo "SwiftPM workspace state not found at .build/workspace-state.json" >&2; echo "Run 'swift package resolve' first." >&2; exit 1)
	@command -v swiftpm2nix >/dev/null || (echo "swiftpm2nix not found in PATH." >&2; echo "Run this target inside 'nix develop'." >&2; exit 1)
	@swiftpm2nix

# Convenience target to update nix/ and then build.
nix_build: nix_update
	nix build
