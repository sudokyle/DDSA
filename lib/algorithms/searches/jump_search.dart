import 'dart:html';
import 'dart:math';

/// Searches [list] for [find] using the jump search method
/// This algorithm assumes that [list] is in ascending order
///
///
/// -1 is returned if [find] not in [list], returns index value of [find] if present in [list]

int jumpSearch<J extends Comparable>(List<J> list, J find) {
  var numItems = list.length;
  var index = 0;
  var jump = sqrt(numItems).floor();

  while(list[min(jump,numItems)-1].compareTo(find) < 0) {
        index = jump;
        jump += jump;
        if(index >= numItems) {
          return -1;
        }
  }
      while()
      return -1;
  }


