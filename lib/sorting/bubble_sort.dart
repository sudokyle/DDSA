List<T> bubbleSort<T extends Comparable>(List<T> unorderedList) {
  if (unorderedList.isEmpty) return unorderedList;
  final sortedList = List<T>.from(unorderedList);
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

// test, delete this before merge.
List list = [1, 2, 3, 4, 5, 6, 7 , 8, 9, 1, 2, 3, 4, 5, 6, 7,8 ,9 , 10, 1,2,3,4,5];