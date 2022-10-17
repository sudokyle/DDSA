part of miso;

typedef Processor<I, O> = Future<O> Function(I input);

class Process<I extends Object, O extends Object> {
  Process(this._input, this._processor);
  final I _input;
  final Processor<I, O> _processor;

  /// Process to execute in new Isolate. Note that since this is run in
  /// a separate isolate, this function cannot reference anything that is out of
  /// its scope, otherwise an error will occur. Be sure to construct an Input
  /// object that captures everything the function will need to process an output.
  Future<O> run() => _processor(_input);
}
