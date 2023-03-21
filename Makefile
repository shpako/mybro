PRODUCT_NAME=mybro
VERSION=0.0.1

PREFIX?=/usr/local

CD=cd
CP=/bin/cp -Rf
GIT=/usr/bin/git
MKDIR=/bin/mkdir -p
RM=/bin/rm -rf
SED=/usr/bin/sed
SWIFT=/usr/bin/swift
ZIP=/usr/bin/zip -r

SHARED_SWIFT_BUILD_FLAGS = --configuration release --disable-sandbox

TARGET_PLATFORM=universal-apple-macosx
PACKAGE_ZIP="$(PRODUCT_NAME)-$(VERSION)-$(TARGET_PLATFORM).zip"

.PHONY: all
all: build

.PHONY: test
test: clean
	$(SWIFT) test

# Disable sandbox since SwiftPM needs to access to the internet to fetch dependencies
.PHONY: build
build:
	$(SWIFT) build $(SHARED_SWIFT_BUILD_FLAGS)

.PHONY: package-darwin-x86_64
package-darwin-x86_64:
	$(eval TARGET_TRIPLE := x86_64-apple-macosx)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"

.PHONY: package-darwin-arm64
package-darwin-arm64:
	$(eval TARGET_TRIPLE := arm64-apple-macosx)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"

.PHONY: package-darwin-universal
package-darwin-universal:
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --arch x86_64 --arch arm64)
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"


.PHONY: install
install: build
	$(eval BINARY_DIRECTORY := $(PREFIX)/bin)
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SHARED_SWIFT_BUILD_FLAGS)))
	$(MKDIR) $(BINARY_DIRECTORY)
	$(CP) "$(BUILD_DIRECTORY)/$(PRODUCT_NAME)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: package-darwin-universal package-darwin-x86_64 package-darwin-arm64

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(PRODUCT_NAME)"

.PHONY: clean
clean:
	$(SWIFT) package clean

