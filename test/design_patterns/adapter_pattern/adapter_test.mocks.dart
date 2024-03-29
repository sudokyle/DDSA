// Mocks generated by Mockito 5.0.16 from annotations
// in DDSA/test/design_patterns/adapter_test.dart.
// Do not manually edit this file.

import 'package:DDSA/design_patterns/adapter_pattern/bird.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [Sparrow].
///
/// See the documentation for Mockito's code generation for more information.
class MockSparrow extends _i1.Mock implements _i2.Sparrow {
  MockSparrow() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String fly() =>
      (super.noSuchMethod(Invocation.method(#fly, []), returnValue: '')
          as String);
  @override
  String makeSound() =>
      (super.noSuchMethod(Invocation.method(#makeSound, []), returnValue: '')
          as String);
  @override
  String toString() => super.toString();
}
