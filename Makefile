.PHONY: test
test:
	 pub run test/ddsa_test.dart

.PHONY: format
format:
	dart format lib test

.PHONY: build
build:
	pub run build_runner build

.PHONY: watch
watch:
	pub run build_runner watch