num oneDimensionalMultiplication(List<num> A, List<num> B) {
  if (A.isEmpty && B.isEmpty) {
    throw Exception('Vectors cannot be empty.');
  }
  if (A.length != B.length) {
    throw Exception(
        "Length of vector A (${A.length}) isn't equal to length of vector B (${B.length}). They must be equal.");
  }
  num sum = 0;
  for (var i = 0; i < A.length; i++) {
    sum += A[i] * B[i];
  }
  return sum;
}

List<List<num>> dotProduct(List<List<num>> A, List<List<num>> B) {
  if (A.isEmpty && B.isEmpty) {
    throw Exception('Matrices cannot be empty.');
  }
  if (A.length != B.first.length || A.first.length != B.length) {
    throw Exception(
        "Length of Matrix A rows (${A.length}) isn't equal to length of Matrix B columns (${B.first.length}). They must be equal.");
  }
  final matrix = List<List<num>>.generate(
      A.length, (index) => List<num>.generate(B.first.length, (_) => 0));
  for (var x = 0; x < A.length; x++) {
    for (var y = 0; y < B.first.length; y++) {
      matrix[x][y] = oneDimensionalMultiplication(
          A[x], List.generate(B.length, (index) => B[index][y]));
    }
  }
  return matrix;
}
