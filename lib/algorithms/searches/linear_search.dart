//for loop to linearly search through list and locate find
//returns -1 if find not in list, returns index value of find if present in list
int linearSearch(List<int> list, int find) {
  var index = list.length;

  for (var i = 0; i < index; i++) {
    if (list[i] == find) {
      return i;
    }
  }
  return -1;
}
/*
void main() {
  final listTestCases = <List<int>>[
    [],
    [1],
    [1, 5, -100, 50, 30032],
    [1, 4, 2, 6, 30, 56, 46, 5, 24, 58, 3, 4444],
  ];

  for (var testCase in listTestCases) {
    print(linearSearch(testCase, 5));
  }
  */
