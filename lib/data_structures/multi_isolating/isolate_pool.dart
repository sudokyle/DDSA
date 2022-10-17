part of miso;

// MISO Soup (Multi-ISOlated Programming) Pool => Soup
class IsolatePool<I extends Object, O extends Object> {
  IsolatePool(int poolSize)
      : poolSize = poolSize > 0
            ? poolSize
            : throw Exception(
                'Cannot have an IsolatePool with size less than or equal to zero.'),
        _processingPorts = [],
        _processQueue = Queue();
  final int poolSize;
  final List<ReceivePort> _processingPorts;
  final Queue<Process<I, O>> _processQueue;
  final StreamController<O> _processOutputController =
      StreamController.broadcast();
  Stream<O> get outputStream => _processOutputController.stream;
  bool get _hasAvailableIsolates => _processingPorts.length < poolSize;
  int get activeProcessCount => _processingPorts.length;

  Future<void> dispose() async {
    await _processOutputController.close();
  }

  void addProcesses(Iterable<Process<I, O>> processes) =>
      processes.forEach(addProcess);

  void addProcess(Process<I, O> process) {
    _hasAvailableIsolates ? _process(process) : _enqueueProcess(process);
  }

  // ---- Processing ---- \\

  static Future<void> _isolateProcessor(_IsolateData isoData) async {
    final data = await isoData.process.run();
    Isolate.exit(isoData.sp, data);
  }

  void _process(Process<I, O> process) {
    // Create and setup ReceivePort associated with isolate worker.
    final rp = ReceivePort();
    rp.listen((message) => _processCompletion(rp, message));

    // Add to Process Pool and spawn isolate worker.
    _processingPorts.add(rp);
    Isolate.spawn(_isolateProcessor, _IsolateData(rp.sendPort, process));
  }

  void _processCompletion(ReceivePort rp, dynamic output) {
    if (output is O) {
      _processOutputController.add(output);
      rp.close();
      _processingPorts.remove(rp);
      _dequeueProcess();
    }
  }

  // ---- Process Queue Management ---- \\
  void _dequeueProcess() {
    if (_processQueue.isNotEmpty && _hasAvailableIsolates) {
      _process(_processQueue.removeFirst());
    }
  }

  void _enqueueProcess(Process<I, O> process) => _processQueue.add(process);
}

class _IsolateData {
  _IsolateData(this.sp, this.process);
  final SendPort sp;
  final Process process;
}
