// TODO: This is just playing around with the concept come up with simple real world
// example and implement it.
class Target {
  int _testValue;
  int? _testValue4;
  final int _testValue2;
  late int _testValue3;

  Target(this._testValue, this._testValue2) {
    _testValue3 = 4;
  }

  int addFiveFunc() {
    return _testValue + 5;
  }
}

/// This class looks nothing like Target!, but with the [Adapter] class we can
/// use that to make this class work exactly as [Target] does, even though they
/// look and operate nothing alike!!
class Adaptee {
  String _value;
  Adaptee(this._value);

  String get value => _value;
}

class Adapter implements Target {
  Adaptee _adaptee;

  Adapter(this._adaptee) : _testValue = int.parse(_adaptee.value) {
    _testValue3 = 5;
  }

  @override
  int addFiveFunc() {
    return _testValue + 5;
  }

  @override
  int _testValue;

  @override
  late int _testValue3;

  @override
  int? _testValue4;

  @override
  // TODO: implement _testValue2
  int get _testValue2 => _testValue;
}

// Client
void main() {
  final target = Target(5, 5);
  final adapter = Adapter(Adaptee('5'));
  print(target.addFiveFunc());
  print(adapter.addFiveFunc());
}
