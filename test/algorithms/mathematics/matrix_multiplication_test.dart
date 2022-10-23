import 'package:DDSA/algorithms/mathematics/matrix_multiplication.dart';
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
            final m1 = [[1,2]], m2 = [[5,6], [7,8]];
            expect(() => dotProduct(m1, m2), throwsException);
          });
        });
        group('with valid input', () {
          test('produces correct output', () {
            final m1 = [[1,2], [3,4]], m2 = [[5,6], [7,8]];
            final product = dotProduct(m1, m2);
            expect(product[0][0], equals(19));
            expect(product[0][1], equals(22));
            expect(product[1][0], equals(43));
            expect(product[1][1], equals(50));
          });
        });
      });
    });
  });
}