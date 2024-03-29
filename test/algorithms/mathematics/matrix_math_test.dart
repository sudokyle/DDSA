import 'package:DDSA/algorithms/mathematics/matrix_math.dart';
import 'package:test/test.dart';

void main() {
  group('matrix', () {
    group('1 dimension', () {
      group('multiplication', () {
        group('with empty vectors', () {
          test('throws exception', () {
            final v1 = <num>[], v2 = <num>[];
            expect(() => oneDimensionalMultiplication(v1, v2), throwsException);
          });
        });
        group('with unequal lengths', () {
          test('throws exception', () {
            final v1 = <num>[1, 2, 3], v2 = <num>[1, 2, 3, 4, 5];
            expect(() => oneDimensionalMultiplication(v1, v2), throwsException);
          });
        });
        group('with valid input', () {
          test('produces correct output', () {
            final v1 = <num>[1, 2, 3, 4, 5], v2 = <num>[1, 2, 3, 4, 5];
            expect(oneDimensionalMultiplication(v1, v2), equals(55));
          });
        });
      });
      group('addition', () {
        group('with empty vectors', () {
          test('throws exception', () {
            expect(vectorAdd([], []), equals([]));
          });
        });
        group('with unequal lengths', () {
          test('throws exception', () {
            expect(() => vectorAdd([1, 2, 3], [1, 2]), throwsException);
          });
        });
        group('with valid input', () {
          test('produces valid output', () {
            expect(vectorAdd([1, 2, 3], [1, 2, 3]), equals([2, 4, 6]));
          });
        });
      });
      group('subtraction', () {
        group('with empty vectors', () {
          test('throws exception', () {
            expect(vectorSubtract([], []), equals([]));
          });
        });
        group('with unequal lengths', () {
          test('throws exception', () {
            expect(() => vectorSubtract([1, 2, 3], [1, 2]), throwsException);
          });
        });
        group('with valid input', () {
          test('produces valid output', () {
            expect(vectorSubtract([1, 2, 3], [1, 2, 3]), equals([0, 0, 0]));
          });
        });
      });
    });

    group('2 dimensions', () {
      group('multiplication', () {
        group('with empty matrices', () {
          test('throws exception', () {
            final m1 = <List<num>>[], m2 = <List<num>>[];
            expect(() => dotProduct(m1, m2), throwsException);
          });
        });
        group('with invalid dimensions', () {
          test('throws exception', () {
            final m1 = [
                  [1, 2]
                ],
                m2 = [
                  [5, 6],
                  [7, 8]
                ];
            expect(() => dotProduct(m1, m2), throwsException);
          });
        });
        group('with valid input', () {
          test('produces correct output', () {
            final m1 = [
                  [1, 2, 3],
                  [4, 5, 6],
                ],
                m2 = [
                  [7, 8],
                  [9, 10],
                  [11, 12],
                ];
            final product = dotProduct(m1, m2);
            expect(product[0][0], equals(58));
            expect(product[0][1], equals(64));
            expect(product[1][0], equals(139));
            expect(product[1][1], equals(154));
          });
        });
      });
      group('addition', () {
        group('with empty vectors', () {
          test('throws exception', () {
            expect(matrixAdd([[]], [[]]), equals([[]]));
          });
        });
        group('with unequal lengths', () {
          test('throws exception', () {
            expect(
                () => matrixAdd(
                      [
                        [1, 2, 3],
                        [4, 5, 6],
                        [7, 8, 9],
                      ],
                      [
                        [1, 2, 3],
                        [4, 5, 6],
                      ],
                    ),
                throwsException);
          });
        });
        group('with valid input', () {
          test('produces valid output', () {
            expect(
                matrixAdd(
                  [
                    [1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9],
                  ],
                  [
                    [1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9],
                  ],
                ),
                equals([
                  [2, 4, 6],
                  [8, 10, 12],
                  [14, 16, 18],
                ]));
          });
        });
      });
      group('subtraction', () {
        group('with empty vectors', () {
          test('throws exception', () {
            expect(matrixSubtract([[]], [[]]), equals([[]]));
          });
        });
        group('with unequal lengths', () {
          test('throws exception', () {
            expect(
                () => matrixSubtract(
                      [
                        [1, 2, 3],
                        [4, 5, 6],
                        [7, 8, 9],
                      ],
                      [
                        [1, 2, 3],
                        [4, 5, 6],
                      ],
                    ),
                throwsException);
          });
        });
        group('with valid input', () {
          test('produces valid output', () {
            expect(
                matrixSubtract(
                  [
                    [1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9],
                  ],
                  [
                    [1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9],
                  ],
                ),
                equals([
                  [0, 0, 0],
                  [0, 0, 0],
                  [0, 0, 0],
                ]));
          });
        });
      });
    });
  });
}
