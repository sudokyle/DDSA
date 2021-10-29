import 'bird.dart';
import 'toy_duck.dart';

/// [BirdAdapter] adapts [Bird] interface to [ToyDuck] interface.
/// TARGET: [ToyDuck]
/// ADAPTEE: [Bird]
/// ADAPTER: [BirdAdapter]
class BirdAdapter implements ToyDuck {
  final Bird bird;
  BirdAdapter(this.bird);

  @override
  String squeak() {
    return bird.makeSound();
  }
}
