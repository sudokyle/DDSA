/// Searches [list] using the binary method for [find]
/// Algorithm assumes that [list] is in ascending order
///  search through [list] and locate [find]
/// returns -1 if [find] not in [list], returns index value of [find] if present in [list]
int binarySearch<B extends Comparable>(List<B> list, B find) {
  var numItems = list.length;
  var end = numItems - 1;
  var start = 0;

  for (var i = 0; i < numItems; i++)   {
    var mid = ((end - start)/2).floor();
    if (list[i] == find)  {
      return i;
    }
    else if (list[mid].compareTo(find) > 0)  {
      end = mid - 1;
    }
    else    {
      start = mid + 1;
    }
  }
  return -1;
}

  }



}