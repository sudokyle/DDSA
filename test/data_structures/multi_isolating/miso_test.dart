import 'package:DDSA/data_structures/multi_isolating/miso.dart';
import 'package:test/test.dart';

void main() {
  group('IsolatePool', () {
    void expectPool({
      required int initialProcesses,
      required int totalProcessed,
      required int expectedInitialProcess,
      required int expectedTotalProcess,
        }) {
      expect(initialProcesses, equals(expectedInitialProcess));
      expect(totalProcessed, equals(expectedTotalProcess));
    }

    group('when created with poolSize of less than or equal to zero', () {
      test('then exception is thrown', () {
        expect(() => IsolatePool(0), throwsException);
        expect(() => IsolatePool(-1), throwsException);
        expect(() => IsolatePool(1), isNot(throwsException));
      });
    });

    group('when given', () {
      group('less than poolSize processes', () {
        test('then starts all processes and completes', () async {
          final isoPool = IsolatePool(5);
          isoPool.addProcesses([
            Process<String, int>('1', (input) => Future.value(int.parse(input))),
            Process<String, int>('2', (input) => Future.value(int.parse(input))),
            Process<String, int>('3', (input) => Future.value(int.parse(input))),
            Process<String, int>('4', (input) => Future.value(int.parse(input))),
          ]);
          expect(isoPool.activeProcessCount, equals(4));
          expect(await isoPool.outputStream.take(4).length, equals(4));
        });
      });

      group('equal to poolSize processes', () {
        test('then starts all processes and completes', () async {
          final isoPool = IsolatePool(5);
          isoPool.addProcesses([
            Process<String, int>('1', (input) => Future.value(int.parse(input))),
            Process<String, int>('2', (input) => Future.value(int.parse(input))),
            Process<String, int>('3', (input) => Future.value(int.parse(input))),
            Process<String, int>('4', (input) => Future.value(int.parse(input))),
            Process<String, int>('5', (input) => Future.value(int.parse(input))),
          ]);
          expect(isoPool.activeProcessCount, equals(5));
          expect(await isoPool.outputStream.take(5).length, equals(5));
        });
      });

      group('more than poolSize processes', () {
        test('then starts poolSize number of processes and completes them', () async {
          final isoPool = IsolatePool(5);
          Future<int> processor(String input) async => int.parse(input);
          isoPool.addProcesses([
            Process<String, int>('1', processor),
            Process<String, int>('2', processor),
            Process<String, int>('3', processor),
            Process<String, int>('4', processor),
            Process<String, int>('5', processor),
            Process<String, int>('6', processor),
            Process<String, int>('7', processor),
          ]);
          expect(isoPool.activeProcessCount, equals(5));
          expect(await isoPool.outputStream.take(7).length, equals(7));
        });
        test('then consumes queued processes as processes in pool completes.', () {
        });
      });
    });
  });
}