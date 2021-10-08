List<T> mergeSort<T extends Comparable>(List<T> unorderedList) {
  // Base case 1
  if ((unorderedList.isEmpty) || (unorderedList.length == 1)) {
    return unorderedList;
  }

  final left =
      mergeSort(unorderedList.sublist(0, (unorderedList.length / 2).floor()));
  final right = mergeSort(unorderedList.sublist(
      (unorderedList.length / 2).floor(), unorderedList.length));
  return _merge(left, right);
}

List<T> _merge<T extends Comparable>(List<T> left, List<T> right) {
  final orderedList = <T>[];
  var leftIndex = 0, rightIndex = 0;
  while ((leftIndex < left.length) && rightIndex < right.length) {
    if (left[leftIndex].compareTo(right[rightIndex]) < 0) {
      orderedList.add(left[leftIndex]);
      leftIndex++;
    } else {
      orderedList.add(right[rightIndex]);
      rightIndex++;
    }
  }
  // After first while loop it WILL be the case that at least one of
  // these while loops will never execute a single loop.
  while (leftIndex < left.length) {
    orderedList.add(left[leftIndex]);
    leftIndex++;
  }

  while (rightIndex < right.length) {
    orderedList.add(right[rightIndex]);
    rightIndex++;
  }

  return orderedList;
}
