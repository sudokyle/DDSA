List<T> selectionSort<T extends Comparable>(List<T> unorderedList) {
  if (unorderedList?.isEmpty ?? true) return unorderedList;
  final orderedList = List<T>.from(unorderedList);
  for (var i = 0; i < orderedList.length; i++) {
    var minIndex = i;
    for (var x = i; x < orderedList.length; x++) {
      if (orderedList[x].compareTo(orderedList[minIndex]) < 0) {
        minIndex = x;
      }
    }
    final swap = orderedList[minIndex];
    orderedList[minIndex] = orderedList[i];
    orderedList[i] = swap;
  }
  return orderedList;
}
