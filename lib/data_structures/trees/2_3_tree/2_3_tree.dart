import 'node.dart';

// todo:: Don't allow duplicates to be inserted!
class TwoThreeTree<T extends Comparable> {
  TwoThreeTree({T? value})
      : _root = value == null ? ZeroNode() : TwoNode<T>.createLeaf(value);
  Node<T> _root;

  factory TwoThreeTree.fromList(Iterable<T> values) {
    final tree = TwoThreeTree<T>();
    values.forEach(tree.insert);
    return tree;
  }

  int get height {
    var height = 0;
    Node<T>? node = _root;
    while (node != null && node.hasChildren) {
      node = node is TwoNode<T> ? node.left : (node as ThreeNode<T>).left;
      ++height;
    }
    return height;
  }

  Node<T>? nodeByPath(String path) {
    final segments = path.split('/');
    if (segments.isEmpty) return _root;
    Node<T>? node = _root;
    for (final segment in segments) {
      final direction = segment.toLowerCase();
      if (direction == 'left') {
        node = node is TwoNode<T> ? node.left : (node as ThreeNode<T>).left;
      } else if (direction == 'right') {
        node = node is TwoNode<T> ? node.right : (node as ThreeNode<T>).right;
      } else if (direction == 'middle') {
        node = node is ThreeNode<T>
            ? node.middle
            : throw Exception(
                'Attempting to access a middle node on a TwoNode.');
      }
    }
    return node;
  }

  void insert(T newValue) {
    _root = _insert<T>(newValue, _root);

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

  static Node<X> _insert<X extends Comparable>(
      X newValue, Node<X> currentNode) {
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
      if (newChild is FourNode<X>) {
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

        if (parent is TwoNode<X>) {
          return ThreeNode<X>.create(
            isLeftUpdate ? newChild.middleValue : parent.value,
            isRightUpdate ? newChild.middleValue : parent.value,
            isLeftUpdate ? newLeftSubTree : parent.left,
            isLeftUpdate ? newRightSubTree : newLeftSubTree,
            isRightUpdate ? newRightSubTree : parent.right,
          );
        } else if (parent is ThreeNode<X>) {
          return FourNode<X>.create(
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

  static ChildUpdate<X> _getChildNodeToTraverse<X extends Comparable>(
      X newValue, Node<X> parent) {
    late final ChildUpdate<X> childNode;
    if (parent is TwoNode<X>) {
      final traverseRight = parent.value.compareTo(newValue) < 0;
      childNode = ChildUpdate(
          childKey: traverseRight ? ChildKey.right : ChildKey.left,
          nextChildNode: traverseRight ? parent.right : parent.left,
          updateChild: (Node<X> node) {
            if (traverseRight) {
              parent.right = node;
            } else {
              parent.left = node;
            }
          });
    } else if (parent is ThreeNode<X>) {
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
        updateChild: (Node<X> node) {
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
