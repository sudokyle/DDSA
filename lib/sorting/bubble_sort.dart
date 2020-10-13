List<T> bubbleSort<T extends Comparable>(List<T> list) {
  final sortedList = List<T>.from(list);
  var swapped = false;
  do {
    swapped = false;
    for (var i = 1; i < sortedList.length; i++) {
      if (sortedList[i - 1].compareTo(sortedList[i]) > 0) {
        final swap = sortedList[i - 1];
        sortedList[i - 1] = sortedList[i];
        sortedList[i] = swap;
        swapped = true;
      } else {}
    }
  } while (swapped);
  return sortedList;
}
