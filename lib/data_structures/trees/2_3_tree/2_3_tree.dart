import 'node.dart';

// todo:: Don't allow duplicates to be inserted!
class TwoThreeTree<T extends Comparable> {
  TwoThreeTree({T? value})
      : _root = value == null ? ZeroNode() : TwoNode<T>.createLeaf(value);
  Node<T> _root;

  void insert(T newValue) {
    _root = _insert(newValue, _root);

    if (_root is FourNode<T>) {
      final fourNode = _root as FourNode<T>;
      final leftSubTree = _root.hasChildren
          ? TwoNode<T>.create(
              fourNode.leftValue, fourNode.left, fourNode.middleLeft)
          : TwoNode<T>.createLeaf(fourNode.leftValue);
      final rightSubTree = _root.hasChildren
          ? TwoNode<T>.create(
              fourNode.rightValue, fourNode.middleRight, fourNode.right)
          : TwoNode<T>.createLeaf(fourNode.rightValue);
      _root = TwoNode.create(fourNode.middleValue, leftSubTree, rightSubTree);
    }
  }

  Node<T> _insert(T newValue, Node<T> currentNode) {
    // Base Case: initial Root
    if (currentNode is ZeroNode) {
      return leafNodeBuilder(newValue);
    }

    // Base Case: Leaf Node Insertion
    if (!currentNode.hasChildren) {
      // Insert
      return leafNodeBuilder(newValue, insertionNode: currentNode);
    }

    // Traverse / Promote Case
    if (currentNode.hasChildren) {
      final parent = currentNode;
      final childUpdate = _getChildNodeToTraverse(newValue, parent);
      final newChild = _insert(newValue, childUpdate.nextChildNode);
      if (newChild is FourNode<T>) {
        // Promote newChild Values to balance
        final newLeftSubTree = newChild.hasChildren
            ? TwoNode.create(
                newChild.leftValue, newChild.left, newChild.middleLeft)
            : TwoNode.createLeaf(newChild.leftValue);
        final newRightSubTree = newChild.hasChildren
            ? TwoNode.create(
                newChild.rightValue, newChild.middleRight, newChild.right)
            : TwoNode.createLeaf(newChild.rightValue);
        final isLeftUpdate = childUpdate.childKey == ChildKey.left;
        final isRightUpdate = childUpdate.childKey == ChildKey.right;
        // print('Good, key: ${childUpdate.childKey}');
        // print('newChild: $newChild');
        // print('LeftSubTree: $newLeftSubTree ${newLeftSubTree.hasChildren}');
        // print('RightSubTree: $newRightSubTree ${newRightSubTree.hasChildren}');

        if (parent is TwoNode<T>) {
          final leftChild = isLeftUpdate ? newLeftSubTree : parent.left;
          final middleChild = isLeftUpdate ? newRightSubTree : newLeftSubTree;
          final rightChild = isRightUpdate ? newRightSubTree : parent.right;
          // print('Left: $leftChild ${leftChild.hasChildren}');
          // print('Middle: $middleChild ${middleChild.hasChildren}');
          // print('Right: $rightChild ${rightChild.hasChildren}');

          return ThreeNode<T>.create(
            isLeftUpdate ? newChild.middleValue : parent.value,
            isRightUpdate ? newChild.middleValue : parent.value,
            isLeftUpdate ? newLeftSubTree : parent.left,
            isLeftUpdate ? newRightSubTree : newLeftSubTree,
            isRightUpdate ? newRightSubTree : parent.right,
          );
        } else if (parent is ThreeNode<T>) {
          return FourNode<T>.create(
            isLeftUpdate ? newChild.middleValue : parent.leftValue,
            isLeftUpdate
                ? parent.leftValue
                : isRightUpdate
                    ? parent.rightValue
                    : newChild.middleValue,
            isRightUpdate ? newChild.middleValue : parent.rightValue,
            isLeftUpdate ? newLeftSubTree : parent.left, // Left SubTree
            isLeftUpdate
                ? newRightSubTree
                : isRightUpdate
                    ? parent.middle
                    : newLeftSubTree, // Middle Left SubTree
            isLeftUpdate
                ? parent.middle
                : isRightUpdate
                    ? newLeftSubTree
                    : newRightSubTree, // Middle Right SubTree
            isRightUpdate ? newRightSubTree : parent.right, // Right SubTree
          );
        }
      }

      // Otherwise, just update the child
      childUpdate.updateChild(newChild);
      return parent;
    }

    throw Exception('Invalid Insertion State');
  }

  ChildUpdate<T> _getChildNodeToTraverse(T newValue, Node<T> parent) {
    late final ChildUpdate<T> childNode;
    if (parent is TwoNode<T>) {
      final traverseRight = parent.value.compareTo(newValue) < 0;
      childNode = ChildUpdate(
          childKey: traverseRight ? ChildKey.right : ChildKey.left,
          nextChildNode: traverseRight ? parent.right : parent.left,
          updateChild: (Node<T> node) {
            if (traverseRight) {
              parent.right = node;
            } else {
              parent.left = node;
            }
          });
    } else if (parent is ThreeNode<T>) {
      final lessThanLeftValue = parent.leftValue.compareTo(newValue) > 0;
      final greaterThanRightValue = parent.rightValue.compareTo(newValue) < 0;

      childNode = ChildUpdate(
        childKey: lessThanLeftValue
            ? ChildKey.left
            : greaterThanRightValue
                ? ChildKey.right
                : ChildKey.middle,
        nextChildNode: lessThanLeftValue
            ? parent.left
            : greaterThanRightValue
                ? parent.right
                : parent.middle,
        updateChild: (Node<T> node) {
          if (lessThanLeftValue) {
            parent.left = node;
          } else if (greaterThanRightValue) {
            parent.right = node;
          } else {
            parent.middle = node;
          }
        },
      );
    }
    return childNode;
  }

  @override
  String toString() {
    final stack = [_root];
    var graph = '';
    while (stack.isNotEmpty) {
      final visit = stack.removeLast();
      graph += '$visit => {${visit.children.join(', ')}}\n';
      stack.addAll(visit.children);
    }
    return graph;
  }
}

enum ChildKey { left, middle, right }

typedef ChildUpdater<T extends Comparable> = void Function(Node<T> newNode);

class ChildUpdate<T extends Comparable> {
  ChildUpdate(
      {required this.nextChildNode,
      required this.updateChild,
      required this.childKey});
  final Node<T> nextChildNode;
  final ChildUpdater<T> updateChild;
  final ChildKey childKey;
}

void main() {
  final tree = TwoThreeTree<int>(value: 20);
  tree.insert(30);
  tree.insert(40);
  tree.insert(15);
  tree.insert(50);
  tree.insert(60);
  tree.insert(25);
  tree.insert(45);
  tree.insert(65);
  tree.insert(35);
  tree.insert(55);

  tree.insert(70);
  tree.insert(80);
  tree.insert(90);
  tree.insert(100);

  tree.insert(110);
  tree.insert(120);
  tree.insert(130);
  tree.insert(140);
  tree.insert(150);
  tree.insert(160);
  tree.insert(170);
  tree.insert(180);
  tree.insert(190);
  tree.insert(200);
  tree.insert(210);
  tree.insert(220);
  tree.insert(230);
  tree.insert(240);
  tree.insert(250);
  tree.insert(260);
  print(tree);
}
