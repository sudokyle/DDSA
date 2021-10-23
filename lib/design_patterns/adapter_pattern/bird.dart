abstract class Bird {
  String fly();
  String makeSound();
}

// Concrete Implementation
class Sparrow implements Bird {
  @override
  String fly() {
    return 'Flying';
  }

  @override
  String makeSound() {
    return 'Chirp Chirp';
  }
}
