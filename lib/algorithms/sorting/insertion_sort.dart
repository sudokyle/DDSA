List<T> insertionSort<T extends Comparable>(List<T> unorderedList) {
  if (unorderedList.isEmpty) return unorderedList;
  final orderedList = List<T>.from(unorderedList);
  for (var unsortedIndex = 1;
      unsortedIndex < orderedList.length;
      unsortedIndex++) {
    var sortedIndex = unsortedIndex - 1;
    var checkIndex = unsortedIndex;
    var isDone = false;
    while ((sortedIndex >= 0) && (!isDone)) {
      if (orderedList[checkIndex].compareTo(orderedList[sortedIndex]) < 0) {
        final swap = orderedList[sortedIndex];
        orderedList[sortedIndex] = orderedList[checkIndex];
        orderedList[checkIndex] = swap;
        checkIndex = sortedIndex;
        sortedIndex--;
      } else {
        isDone = true;
      }
    }
  }
  return orderedList;
}
