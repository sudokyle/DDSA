abstract class ToyDuck {
  String squeak();
}

// Concrete Implementation
class PlasticToyDuck implements ToyDuck {
  @override
  String squeak() {
    return 'Squeak';
  }
}
