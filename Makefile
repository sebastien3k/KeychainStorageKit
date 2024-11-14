# Makefile

SIMULATOR_DEVICE = iPhone 16
SIMULATOR_OS = latest
SCHEME = TestHost
TEST_TARGET = KeychainStorageKitTests

test:
	xcodebuild test \
	    -scheme $(SCHEME) \
	    -destination 'platform=iOS Simulator,name=$(SIMULATOR_DEVICE),OS=$(SIMULATOR_OS)' \
	    -only-testing:$(TEST_TARGET)
