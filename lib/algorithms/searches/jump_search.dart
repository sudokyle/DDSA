import 'dart:html';
import 'dart:math';

/// Searches [list] for [find] using the jump search method
/// This algorithm assumes that [list] is in ascending order
///
/// Algorithm searches by jumping items in the list until items are greater than [find]
/// Then [list] at previous jump point is searched linearly until [find] is found
/// -1 is returned if [find] not in [list], returns index value of [find] if present in [list]

int jumpSearch<J extends Comparable>(List<J> list, J find) {
  var numItems = list.length;
  var index = 0;
  var jump = sqrt(numItems).floor();

  // Algorithm searches by jumping items in the list until items are greater than find
  while (list[min(jump, numItems) - 1].compareTo(find) < 0) {
    index = jump;
    jump += jump;
    if (index >= numItems) {
      return -1;
    }
  }
  // Then at previous jump point is searched linearly until find is found
  while (list[index].compareTo(find) < 0) {
    index++;
    if (index == min(jump, numItems)) {
      return -1;
    }
  }
  if (list[index] == find) {
    return index;
  }
  return -1;
}
