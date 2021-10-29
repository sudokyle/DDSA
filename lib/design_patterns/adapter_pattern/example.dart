import 'bird.dart';
import 'bird_adapter.dart';
import 'toy_duck.dart';

void main() {
  final sparrow = Sparrow();
  final toyDuck = PlasticToyDuck();
  final birdAdapter = BirdAdapter(sparrow);

  print('Sparrow: ${sparrow.makeSound()} - ${sparrow.fly()}');
  print('Toy Duck: ${toyDuck.squeak()}');
  print('Bird Adapter: ${birdAdapter.squeak()}');
}
