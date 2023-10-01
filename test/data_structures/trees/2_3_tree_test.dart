import 'dart:math';
import 'package:DDSA/data_structures/trees/2_3_tree/node.dart';
import 'package:test/test.dart';
import 'package:DDSA/data_structures/trees/2_3_tree/2_3_tree.dart';

void main() {
  final data = [
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
  ];

  group('2-3 Tree', () {
    test('insert', () {
      final twoThreeTree = TwoThreeTree<int>();
      for (final value in data) {
        twoThreeTree.insert(value);
        verifyTree(twoThreeTree);
      }
    });

    test('delete', () {
      final twoThreeTree = TwoThreeTree<int>.fromList(data);
      for (final value in data) {
        print('Tree: $twoThreeTree');
        twoThreeTree.delete(value);
        print('------------------------------');
        print('Tree: $twoThreeTree');
        verifyTree(twoThreeTree);
      }
    });

  });
}

verifyTree(TwoThreeTree tree) {
  final (nodeCount, treeHeight, allBranchesHaveEqualHeight) = getTreeData(tree.root, 0);
  // print('Tree: nodes: $nodeCount, height: $treeHeight, equal heights: $allBranchesHaveEqualHeight');
  expect(allBranchesHaveEqualHeight, isTrue, reason: "Every branch on Tree should have the same height.");

  // The height of the tree should satisfy log3(n) <= height(tree) <= log2(n)
  // print('${log3(nodeCount).round()} <= $treeHeight <= ${log2(nodeCount).round()}');
  expect(treeHeight, greaterThanOrEqualTo(log3(nodeCount).round()));
  expect(treeHeight, lessThanOrEqualTo(log2(nodeCount).round()));
}

double log3(int n) => logBase(n, 3);
double log2(int n) => logBase(n, 2);
double logBase(int n, int base) => log(n)/log(base);

(int nodeCount, int height, bool validHeight) getTreeData<T extends Comparable>(Node<T> node, int height) {
  if (node.hasChildren) {
    if (node is TwoNode<T>) {
      // Non-leaf nodes must have all their children
      expect(node.maybeLeft, isNotNull);
      expect(node.maybeRight, isNotNull);
      // Assert Node Values
      final leftChild = node.left;
      final rightChild = node.right;
      if (leftChild is TwoNode<T>) {
        expect(node.value.compareTo(leftChild.value) > 0, isTrue);
      } else if (leftChild is ThreeNode<T>) {
        expect(node.value.compareTo(leftChild.leftValue) > 0, isTrue);
        expect(node.value.compareTo(leftChild.rightValue) > 0, isTrue);
      }
      if (rightChild is TwoNode<T>) {
        expect(node.value.compareTo(rightChild.value) < 0, isTrue);
      } else if (rightChild is ThreeNode<T>) {
        expect(node.value.compareTo(rightChild.leftValue) < 0, isTrue);
        expect(node.value.compareTo(rightChild.rightValue) < 0, isTrue);
      }

      final (leftNodeCount, leftHeight, leftHeightValid) = getTreeData(node.left, height+1);
      final (rightNodeCount, rightHeight, rightHeightValid) = getTreeData(node.right, height+1);
      // if either leftHeightValid or rightHeightValid is false, the height is wrong and returned height is ignored.
      // otherwise this means the heights at bse case leaf nodes were equal and thus we can just return either left or right height
      // and they will be the same.
      return (1 + leftNodeCount + rightNodeCount, leftHeight, (leftHeightValid && rightHeightValid) && (leftHeight == rightHeight));
    } else if (node is ThreeNode<T>) {
      // Non-leaf nodes must have all their children
      expect(node.maybeLeft, isNotNull);
      expect(node.maybeMiddle, isNotNull);
      expect(node.maybeRight, isNotNull);
      // Assert Node Values
      final leftChild = node.left;
      final middleChild = node.middle;
      final rightChild = node.right;
      expect(node.leftValue.compareTo(node.rightValue) < 0, isTrue, reason: '${node.leftValue} < ${node.rightValue} but got ${node.leftValue.compareTo(node.rightValue)}');
      if (leftChild is TwoNode<T>) {
        expect(node.leftValue.compareTo(leftChild.value) > 0, isTrue);
      } else if (leftChild is ThreeNode<T>) {
        expect(node.leftValue.compareTo(leftChild.leftValue) > 0, isTrue);
        expect(node.leftValue.compareTo(leftChild.rightValue) > 0, isTrue);
      }
      if (middleChild is TwoNode<T>) {
        expect(node.leftValue.compareTo(middleChild.value) < 0, isTrue);
        expect(node.rightValue.compareTo(middleChild.value) > 0, isTrue);
      } else if (middleChild is ThreeNode<T>) {
        expect(node.leftValue.compareTo(middleChild.leftValue) < 0, isTrue);
        expect(node.leftValue.compareTo(middleChild.rightValue) < 0, isTrue);
        expect(node.rightValue.compareTo(middleChild.leftValue) > 0, isTrue);
        expect(node.rightValue.compareTo(middleChild.rightValue) > 0, isTrue);
      }
      if (rightChild is TwoNode<T>) {
        expect(node.rightValue.compareTo(rightChild.value) < 0, isTrue);
      } else if (rightChild is ThreeNode<T>) {
        expect(node.rightValue.compareTo(rightChild.leftValue) < 0, isTrue);
        expect(node.rightValue.compareTo(rightChild.rightValue) < 0, isTrue);
      }

      final (leftNodeCount, leftHeight, leftHeightValid) = getTreeData(node.left, height+1);
      final (middleNodeCount, middleHeight, middleHeightValid) = getTreeData(node.middle, height+1);
      final (rightNodeCount, rightHeight, rightHeightValid) = getTreeData(node.right, height+1);
      return (1 + leftNodeCount + middleNodeCount + rightNodeCount, leftHeight, (leftHeightValid && middleHeightValid && rightHeightValid) && (leftHeight == middleHeight && middleHeight == rightHeight));
    }
    throw Exception('Node in TwoThreeTree is not a Two or Three node, it is ${node.runtimeType} which is not valid.');
  }

  // Base Case: Leaf Nodes!
  if (node is TwoNode<T>) {
    return (1, height, true);
  } else if (node is ThreeNode<T>) {
    return (1, height, true);
  }
  throw Exception('Node in TwoThreeTree is not a Two or Three node, it is ${node.runtimeType} which is not valid.');
}