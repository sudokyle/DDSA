/// Searches [list] linearly for [find]
///
/// For loop to linearly search through [list] and locate [find]
/// returns -1 if [find] not in [list], returns index value of [find] if present in [list]
int linearSearch<L>(List<L> list, L find) {
  var index = list.length;

  for (var i = 0; i < index; i++) {
    if (list[i] == find) {
      return i;
    }
  }
  return -1;
}
