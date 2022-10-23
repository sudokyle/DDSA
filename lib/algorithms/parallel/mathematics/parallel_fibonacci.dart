import 'dart:async';

import 'package:DDSA/data_structures/multi_isolating/miso.dart';

Map<int, int> memo = {};

void main() async {
  await evaluate(memoFib, 20, 'Memoized Fib');
  await evaluate(fib, 20, 'Fib');
  await evaluate(pFib, 20, 'Parallel Fib');
}


Future<void> evaluate(dynamic Function(int) fib, int input, String title) async {
  final stopwatch = Stopwatch();
  stopwatch.start();
  print('$title Result: ${await fib(input)}');
  stopwatch.stop();
  printElapsedTimeInSeconds(stopwatch.elapsedMilliseconds);
  stopwatch.reset();
}

void printElapsedTimeInSeconds(int elapsedMilliseconds) {
  print('${elapsedMilliseconds / 1000} seconds');
}

int fib(int n) {
  if (n <= 1) return n;
  return fib(n-1) + fib(n-2);
}

int memoFib(int n) {
  if (memo.containsKey(n)) return memo[n]!;
  if (n <= 1) return n;
  memo[n] = fib(n-1) + fib(n-2);
  return memo[n]!;
}

Future<int> pFib(int n) async {
  if (n <= 1) return n;
  final pool = IsolatePool<int, int>(2);
  pool.addProcesses([
    Process<int,int>(n-1, pFib),
    Process<int,int>(n-2, pFib)
  ]);
  return await pool.outputStream.take(2).reduce((n1, n2) => n1 + n2);
}

int nonRFib(int n) {
  int total = 0;
  while (n > 0) {
    
  }
}


