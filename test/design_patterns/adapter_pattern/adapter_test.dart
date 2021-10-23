import 'package:DDSA/design_patterns/adapter_pattern/bird.dart';
import 'package:DDSA/design_patterns/adapter_pattern/bird_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'adapter_test.mocks.dart';

@GenerateMocks([Sparrow])
void main() {
  group('Adapter:', () {
    group('When a Bird is adapted to a ToyDuck', () {
      group('and squeak is called', () {
        test('then makeSound is invoked on the adaptee Bird', () {
          final expectedSqueak = 'sparrow_make_sound';
          final sparrow = MockSparrow();
          when(sparrow.makeSound()).thenReturn(expectedSqueak);
          expect(BirdAdapter(sparrow).squeak(), equals(expectedSqueak));
          verify(sparrow.makeSound()).called(1);
        });
      });
    });
  });
}
