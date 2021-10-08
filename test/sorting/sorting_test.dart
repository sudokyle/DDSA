import 'package:DDSA/sorting/bubble_sort.dart';
import 'package:DDSA/sorting/insertion_sort.dart';
import 'package:DDSA/sorting/merge_sort.dart';
import 'package:DDSA/sorting/selection_sort.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart' hide insertionSort, mergeSort;

typedef ComparableSorter<T extends Comparable> = List<T> Function(List<T> unorderedList);

void main() {
  group('Sorting:', () {
    late List<int> emptyList;
    late List<int> singleValueList;
    late List<int> twoValueList;
    late List<int> alreadyOrderedList;
    late List<int> unorderedList;

    setUp(() {
      emptyList = [];
      singleValueList = [3];
      twoValueList = [4, 3];
      alreadyOrderedList = [30, 45, 67, 67, 82, 100, 10459];
      unorderedList = [
        3,
        44,
        38,
        5,
        47,
        15,
        36,
        26,
        27,
        2,
        38,
        46,
        4,
        19,
        50,
        48
      ];
    });

    void verifySort(ComparableSorter sorter) {
      final equals = ListEquality().equals;

      test('returns empty list when list is empty', () {
        expect(sorter(emptyList).isEmpty, isTrue);
      });
      test('sorts single valued lists properly', () {
        expect(equals(sorter(singleValueList), [3]), isTrue);
      });
      test('sorts two valued lists properly', () {
        expect(equals(sorter(twoValueList), [3, 4]), isTrue);
      });
      test('sorts already sorted lists properly', () {
        expect(equals(sorter(alreadyOrderedList), alreadyOrderedList), isTrue);
      });
      test('sorts unordered lists properly', () {
        expect(
            equals(sorter(unorderedList),
                [2, 3, 4, 5, 15, 19, 26, 27, 36, 38, 38, 44, 46, 47, 48, 50]),
            isTrue);
      });
    }

    group('bubble Sort', () => verifySort(bubbleSort));

    group('Selection Sort', () => verifySort(selectionSort));

    group('Insertion Sort', () => verifySort(insertionSort));

    group('Merge Sort', () => verifySort(mergeSort));
  });
}
