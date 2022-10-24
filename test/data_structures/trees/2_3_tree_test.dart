import 'package:DDSA/data_structures/trees/2_3_tree/node.dart';
import 'package:test/test.dart';
import 'package:DDSA/data_structures/trees/2_3_tree/2_3_tree.dart';

void main() {
  group('2-3 Tree', () {
    group('When tree is given null value(s)', () {});
    group('When tree is empty', () {});
    group('When tree has one element', () {
      late final TwoThreeTree tree;
      setUp(() {
        tree = TwoThreeTree.fromList([5]);
      });
    });
    group('When tree has two elements', () {
      late final TwoThreeTree tree;
      setUp(() {
        tree = TwoThreeTree.fromList([5, -5]);
      });
    });
    group('When tree has many elements', () {
      late final TwoThreeTree<int> tree;

      void verifyTwoNode(String path, {required dynamic expectedValue}) {
        final node = tree.nodeByPath(path);
        expect(node is TwoNode<int>, isTrue);
        if (node is TwoNode<int>) {
          expect(node.value, equals(expectedValue));
        }
      }

      void verifyThreeNode(String path,
          {required dynamic expectedLeftValue,
          required dynamic expectedRightValue}) {
        final node = tree.nodeByPath(path);
        expect(node is ThreeNode<int>, isTrue);
        if (node is ThreeNode<int>) {
          expect(node.leftValue, equals(expectedLeftValue));
          expect(node.rightValue, equals(expectedRightValue));
        }
      }

      setUp(() {
        tree = TwoThreeTree.fromList([
          30,
          40,
          15,
          50,
          60,
          25,
          45,
          65,
          35,
          55,
          70,
          80,
          90,
          100,
          110,
          120,
          130,
          140,
          150,
          160,
          170,
          180,
          190,
          200,
          210,
          220,
          230,
          240,
          250,
          260,
          20
        ]);
      });

      test('Then Tree is balanced correctly.', () {
        // Verify Balanced trees height.
        expect(tree.height, equals(3));

        // Root Node of Tree
        verifyThreeNode('/', expectedLeftValue: 60, expectedRightValue: 130);

        // Left SubTree
        verifyTwoNode('/left', expectedValue: 40);
        verifyThreeNode('/left/left',
            expectedLeftValue: 20, expectedRightValue: 30);
        verifyTwoNode('/left/left/left', expectedValue: 15);
        verifyTwoNode('/left/left/middle', expectedValue: 25);
        verifyTwoNode('/left/left/right', expectedValue: 35);
        verifyTwoNode('/left/right', expectedValue: 50);
        verifyTwoNode('/left/right/left', expectedValue: 45);
        verifyTwoNode('/left/right/right', expectedValue: 55);

        // Middle SubTree
        verifyTwoNode('/middle', expectedValue: 90);
        verifyTwoNode('/middle/left', expectedValue: 70);
        verifyTwoNode('/middle/left/left', expectedValue: 65);
        verifyTwoNode('/middle/left/right', expectedValue: 80);
        verifyTwoNode('/middle/right', expectedValue: 110);
        verifyTwoNode('/middle/right/left', expectedValue: 100);
        verifyTwoNode('/middle/right/right', expectedValue: 120);

        // Right SubTree
        verifyThreeNode('/right',
            expectedLeftValue: 170, expectedRightValue: 210);
        verifyTwoNode('/right/left', expectedValue: 150);
        verifyTwoNode('/right/left/left', expectedValue: 140);
        verifyTwoNode('/right/left/right', expectedValue: 160);
        verifyTwoNode('/right/middle', expectedValue: 190);
        verifyTwoNode('/right/middle/left', expectedValue: 180);
        verifyTwoNode('/right/middle/right', expectedValue: 200);
        verifyThreeNode('/right/right',
            expectedLeftValue: 230, expectedRightValue: 250);
        verifyTwoNode('/right/right/left', expectedValue: 220);
        verifyTwoNode('/right/right/middle', expectedValue: 240);
        verifyTwoNode('/right/right/right', expectedValue: 260);
      });
    });
  });
}
