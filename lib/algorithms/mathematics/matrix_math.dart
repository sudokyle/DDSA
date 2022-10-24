// todo: Scalar multiplication
// todo: Scalar division

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

List<num> vectorAdd(List<num> A, List<num> B) => A.length == B.length
    ? List.generate(A.length, (index) => A[index] + B[index])
    : throw Exception('Vectors must be of same length to add.');

List<num> vectorSubtract(List<num> A, List<num> B) => A.length == B.length
    ? List.generate(A.length, (index) => A[index] - B[index])
    : throw Exception('Vectors must be of same length to subtract.');

List<List<num>> matrixAdd(List<List<num>> A, List<List<num>> B) {
  void throwException() =>
      throw Exception('Matrices must be of equal dimensions to add.');
  if (A.length != B.length) throwException();
  if (A.isEmpty) return [[]];
  if (A.first.length != B.first.length) throwException();
  return List.generate(A.length, (index) => vectorAdd(A[index], B[index]));
}

List<List<num>> matrixSubtract(List<List<num>> A, List<List<num>> B) {
  void throwException() =>
      throw Exception('Matrices must be of equal dimensions to subtract.');
  if (A.length != B.length) throwException();
  if (A.isEmpty) return [[]];
  if (A.first.length != B.first.length) throwException();
  return List.generate(A.length, (index) => vectorSubtract(A[index], B[index]));
}
