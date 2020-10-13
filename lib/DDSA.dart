import 'sorting/bubble_sort.dart';

main() {
  var validList = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48];
  var invalidList = [
    Invalid(3), Invalid(1), Invalid(2), Invalid(6), Invalid(4), Invalid(5),
  ];

  print(bubbleSort(validList));
  print(bubbleSort<Invalid>(invalidList));
}
