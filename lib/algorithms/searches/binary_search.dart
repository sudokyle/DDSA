/// Searches [list] for [find] using the binary method
/// This algorithm assumes that [list] is in ascending order
///
/// If the midpoint value matches [find], its position in [list] is returned
/// If the midpoint value is less than [find], the search continues in the lower half of [list].
/// If the midpoint value is greater than [find], the search continues in the upper half of [list]
/// In this way, half of [list] is eliminated on every iteration.
/// -1 is returned if [find] not in [list], returns index value of [find] if present in [list]
///
int binarySearch<B extends Comparable>(List<B> list, B find) {
  var numItems = list.length;
  var end = numItems - 1;
  var start = 0;

  for (var i = 0; i < numItems; i++) {
    // first compare end of current index list to beginning of index list
    // to ensure mid variable is not invalid
    // also automatically ends program if [list] is empty
    if (start <= end) {
      var mid = ((end - start)/2).floor();
        if (list[i] == find) {
          return i;
        }
        // If the midpoint value is less than [find],
        // the search continues in the lower half of [list]
          else if (list[mid].compareTo(find) > 0) {
            end = mid - 1;
          }
          //If the midpoint value is greater than [find],
          // the search continues in the upper half of [list]
            else {
              start = mid + 1;
            }
    }
    return -1;
  }
}