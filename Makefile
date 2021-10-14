.PHONY: test
test:
	 pub run test/ddsa_test.dart

.PHONY: format
format:
	dart format lib test