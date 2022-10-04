
import 'package:DDSA/algorithms/searching/jump_search.dart';
import 'package:test/test.dart';

void main() {
  // Empty list case
  // single
  // multiple even
  // multiple odd

  group('JumpSearch:', () {
    group('When searching a list', () {
      final notPresentTest = <T extends Comparable>(List<T> list, T find) {
        group('and the item isn\'t present', () {
          test('then returns -1.', () {
            expect(jumpSearch(list, find), equals(-1));
          });
        });
      };

      final presentTest =
          <T extends Comparable>(List<T> list, T find, int expectedIndex) {
        group('and the item is present', () {
          test('then returns the index of that item.', () {
            expect(jumpSearch(list, find), equals(expectedIndex));
          });
        });
      };

      group('that is empty', () {
        notPresentTest<int>([], 4);
      });
      group('that has a single item', () {
        final testList = [1];
        notPresentTest(testList, 3);
        presentTest(testList, 1, 0);
      });
      group('that has an even number of items', () {
        final testList = [1, 2, 3, 4, 5, 6];
        notPresentTest(testList, 7);
        presentTest(testList, 6, 5);
      });
      group('that has an odd number of items', () {
        final testList = [1, 2, 3, 4, 5];
        notPresentTest(testList, 6);
        presentTest(testList, 3, 2);
      });
    });
  });
}
