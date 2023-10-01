import 'node.dart';

// todo:: Don't allow duplicates to be inserted!
class TwoThreeTree<T extends Comparable> {
  TwoThreeTree({T? value}) : _root = value == null ? ZeroNode() : TwoNode<T>.createLeaf(value);

  factory TwoThreeTree.fromList(Iterable<T> values) {
    final tree = TwoThreeTree<T>();
    values.forEach(tree.insert);
    return tree;
  }

  Node<T> _root;
  bool _usePredecessor = true;

  Node<T> get root => _root;

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
    _root = _insert(newValue, _root);

    if (_root is FourNode<T>) {
      final fourNode = _root as FourNode<T>;
      final leftSubTree = _root.hasChildren ? TwoNode<T>.create(fourNode.leftValue, fourNode.left, fourNode.middleLeft) : TwoNode<T>.createLeaf(fourNode.leftValue);
      final rightSubTree = _root.hasChildren ? TwoNode<T>.create(fourNode.rightValue, fourNode.middleRight, fourNode.right) : TwoNode<T>.createLeaf(fourNode.rightValue);
      _root = TwoNode.create(fourNode.middleValue, leftSubTree, rightSubTree);
    }
  }

  void delete(T removeValue) {
    print('delete: $removeValue');
    final pathToDeleteAtNode = _findNodePath(_root, removeValue);
    late List<Node<T>> replacePath;
    print(pathToDeleteAtNode);
    if (pathToDeleteAtNode.isEmpty) return;
    final deleteAtNode = pathToDeleteAtNode.last;
    if (deleteAtNode.hasChildren) { // we "delete" the found value by replacing it if it has children.
      if (deleteAtNode is ThreeNode<T> && deleteAtNode.leftValue == removeValue) {
        final replacement = _findReplaceValueNode(_usePredecessor ? deleteAtNode.left : deleteAtNode.middle);
        replacePath = replacement.path;
        deleteAtNode.leftValue = replacement.replaceValue;
      } else if (deleteAtNode is ThreeNode<T> && deleteAtNode.rightValue == removeValue) {
        final replacement = _findReplaceValueNode(_usePredecessor ? deleteAtNode.middle : deleteAtNode.right);
        replacePath = replacement.path;
        deleteAtNode.rightValue = replacement.replaceValue;
      } else if (deleteAtNode is TwoNode<T> && deleteAtNode.value == removeValue) {
        final replacement = _findReplaceValueNode(_usePredecessor ? deleteAtNode.left : deleteAtNode.right);
        replacePath = replacement.path;
        deleteAtNode.value = replacement.replaceValue;
      }
    } else {
      replacePath = pathToDeleteAtNode;
    }
    print('Path to delete node: $pathToDeleteAtNode');
    print('Replacement Path: $replacePath');
    final fullPath = pathToDeleteAtNode != replacePath ? mergeNodePaths<T>(pathToDeleteAtNode, replacePath).toList() : pathToDeleteAtNode;

    { // Handle replacement node
      final replacementNode = fullPath.last;
      final parent = fullPath[fullPath.length-2];
      final relationship = parent.relationship(replacementNode);
      if (relationship == ChildKey.left && parent is TwoChildNode<T>) {
        if (replacementNode is ThreeNode<T>) {
          parent.left = TwoNode<T>.createLeaf(_usePredecessor ? replacementNode.rightValue : replacementNode.leftValue);
          return;
        } else if (replacementNode is TwoNode<T>) {
          parent.left = HoleNode<T>.createLeaf();
          fullPath[fullPath.length-1] = parent.left;
        }
      } else if (relationship == ChildKey.right && parent is TwoChildNode<T>) {
        if (replacementNode is ThreeNode<T>) {
          parent.right = TwoNode<T>.createLeaf(_usePredecessor ? replacementNode.rightValue : replacementNode.leftValue);
          return;
        } else if (replacementNode is TwoNode<T>) {
          parent.right = HoleNode<T>.createLeaf();
          fullPath[fullPath.length-1] = parent.right;
        }
      } else if (relationship == ChildKey.middle && parent is ThreeNode<T>) {
        if (replacementNode is ThreeNode<T>) {
          parent.middle = TwoNode<T>.createLeaf(_usePredecessor ? replacementNode.rightValue : replacementNode.leftValue);
          return;
        } else if (replacementNode is TwoNode<T>) {
          parent.middle = HoleNode<T>.createLeaf();
          fullPath[fullPath.length-1] = parent.middle;
        }
      } else {
        throw Exception('Failed to update terminal replacement node with parent. (child: ${replacementNode.runtimeType}, relationship: ${relationship}, parent: ${parent.runtimeType})');
      }
    }

    print('We here');
    // Should only be at this point if there is a twoNode -> HoleNode created that needs to be bubbled.
        { // Bubble HoleNode until it "pops"!
      print('FullPath: $fullPath');
      final bottomUpPath = fullPath.reversed.toList();
      int nodeIndex = 0;
      Node<T> holeNode = bottomUpPath[nodeIndex];
      while(holeNode is HoleNode<T> && nodeIndex < bottomUpPath.length) {
        if (nodeIndex+1 == bottomUpPath.length) { // holeNode is "root"
          _root = holeNode.child;
          ++nodeIndex;
          continue;
        }

        // todo: handle when there is no parent (i.e. root node case)
        final parentNode = bottomUpPath[nodeIndex+1];
        final sibling = parentNode.siblingOf(holeNode);
        final grandParent = nodeIndex+2 < bottomUpPath.length ? bottomUpPath[nodeIndex+2] : null;
        final relationship = parentNode.relationship(holeNode)!;
        if (parentNode is TwoNode<T> && sibling is TwoNode<T>) {  // Case 1
          print('Sibling: $sibling');
          bottomUpPath[nodeIndex] = relationship == ChildKey.left
              ? ThreeNode<T>.createNullable(parentNode.value, sibling.value, holeNode.maybeChild, sibling.maybeLeft, sibling.maybeRight)
              : ThreeNode<T>.createNullable(sibling.value, parentNode.value, sibling.maybeLeft, sibling.maybeRight, holeNode.maybeChild);
          // Update and bubble up HoleNode.
          holeNode.child = bottomUpPath[nodeIndex]; // update the child of the hole node
          bottomUpPath[nodeIndex+1] = holeNode; // set next parent as holeNode (bubble up)
          grandParent?.replace(parentNode, holeNode); // make sure we replace the parent with the holeNode.
        } else if (parentNode is TwoNode<T> && sibling is ThreeNode<T>) {  // Case 2
          final leftChild = relationship == ChildKey.left
              ? TwoNode<T>.createNullable(parentNode.value, holeNode.maybeChild, sibling.maybeLeft)
              : TwoNode<T>.createNullable(sibling.leftValue, sibling.maybeLeft, sibling.maybeMiddle);
          final rightChild = relationship == ChildKey.left
              ? TwoNode<T>.createNullable(sibling.rightValue, sibling.maybeMiddle, sibling.maybeRight)
              : TwoNode<T>.createNullable(parentNode.value, sibling.maybeRight, holeNode.maybeChild);
          final newParent = TwoNode<T>.createNullable(relationship == ChildKey.left ? sibling.leftValue : sibling.rightValue, leftChild, rightChild);;
          bottomUpPath[nodeIndex+1] = newParent;
          grandParent?.replace(parentNode, newParent);
        } else if (parentNode is ThreeNode<T> && sibling is TwoNode<T>) {  // Case 3
          final leftChild = switch(relationship) {
            ChildKey.left => ThreeNode<T>.createNullable(parentNode.leftValue, sibling.value, holeNode.maybeChild, sibling.maybeLeft, sibling.maybeRight),
            ChildKey.middle => ThreeNode<T>.createNullable(sibling.value, parentNode.leftValue, sibling.maybeLeft, sibling.maybeRight, holeNode.maybeChild),
            ChildKey.right => parentNode.left,
          };
          final rightChild = switch(relationship) {
            ChildKey.left || ChildKey.middle => parentNode.right,
            ChildKey.right => ThreeNode<T>.createNullable(sibling.value, parentNode.rightValue, sibling.maybeLeft, sibling.maybeRight, holeNode.maybeChild),
          };
          final newParent = TwoNode<T>.create(switch(relationship) {
            ChildKey.left || ChildKey.middle => parentNode.rightValue,
            ChildKey.right => parentNode.leftValue,
          }, leftChild, rightChild);
          bottomUpPath[nodeIndex+1] = newParent;
          grandParent?.replace(parentNode, newParent);
        } else if (parentNode is ThreeNode<T> && sibling is ThreeNode<T>) { // Case 4
          final leftChild = switch(relationship) {
            ChildKey.left => TwoNode<T>.createNullable(parentNode.leftValue, holeNode.maybeChild, sibling.maybeLeft),
            ChildKey.middle => TwoNode<T>.createNullable(sibling.leftValue, sibling.maybeLeft, sibling.maybeMiddle),
            ChildKey.right => parentNode.left,
          };
          final middleChild = switch(relationship) {
            ChildKey.left => TwoNode<T>.createNullable(sibling.rightValue, sibling.maybeMiddle, sibling.maybeRight),
            ChildKey.middle => TwoNode<T>.createNullable(parentNode.leftValue, sibling.maybeRight, holeNode.maybeChild),
            ChildKey.right => TwoNode<T>.createNullable(sibling.leftValue, sibling.maybeLeft, sibling.maybeMiddle),
          };
          final rightChild = switch(relationship) {
            ChildKey.left || ChildKey.middle => parentNode.right,
            ChildKey.right => TwoNode<T>.createNullable(parentNode.rightValue, sibling.maybeRight, holeNode.maybeChild),
          };

          parentNode.leftValue = switch(relationship) {
            ChildKey.left => sibling.leftValue, // sibling should be middle child
            ChildKey.middle => sibling.rightValue, // sibling should be left child
            ChildKey.right => parentNode.leftValue,
          };
          parentNode.rightValue = switch(relationship) {
            ChildKey.left || ChildKey.middle => parentNode.rightValue,
            ChildKey.right => sibling.rightValue,
          };
          parentNode.left = leftChild;
          parentNode.middle = middleChild;
          parentNode.right = rightChild;
        } else {
          throw Exception('Encountered an error trying to bubble up holeNode. {holeNode: ${holeNode.runtimeType}, parentNode: ${parentNode.runtimeType}, grandParent?: ${grandParent.runtimeType}');
        }

        print('bottomUpPath: $bottomUpPath, $nodeIndex');
        holeNode = bottomUpPath[++nodeIndex];
      }
    }
  }

  @override
  String toString() {
    final stack = [_root];
    var graph = '';
    while (stack.isNotEmpty) {
      final visit = stack.removeLast();
      if (visit.hasChildren) {
        graph += '$visit => {${visit.children.join(', ')}}\n';
        stack.addAll(visit.children);
      } else {
        graph += '$visit\n';
      }
    }
    return graph;
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
        final newLeftSubTree = newChild.hasChildren ? TwoNode.create(newChild.leftValue, newChild.left, newChild.middleLeft) : TwoNode.createLeaf(newChild.leftValue);
        final newRightSubTree = newChild.hasChildren ? TwoNode.create(newChild.rightValue, newChild.middleRight, newChild.right) : TwoNode.createLeaf(newChild.rightValue);
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
            isLeftUpdate ? parent.leftValue : isRightUpdate ? parent.rightValue : newChild.middleValue,
            isRightUpdate ? newChild.middleValue : parent.rightValue,
            isLeftUpdate ? newLeftSubTree : parent.left, // Left SubTree
            isLeftUpdate ? newRightSubTree : isRightUpdate ? parent.middle : newLeftSubTree, // Middle Left SubTree
            isLeftUpdate ? parent.middle : isRightUpdate ? newLeftSubTree : newRightSubTree, // Middle Right SubTree
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

  /// Starting from [node] finds the next predecessor value if [usePredecessor]
  /// is true, or the next successor if [usePredecessor] is false;
  ///
  /// [usePredecessor] defaults to true.
  ReplacePayload<T> _findReplaceValueNode(Node<T> node) {
    var currentNode = node;
    final nodePath = [node];
    while(currentNode.hasChildren) { // Find Terminal Node
      if (currentNode is ThreeNode<T>) {
        currentNode = _usePredecessor ? currentNode.right : currentNode.left;
      } else if (node is TwoNode<T>) {
        currentNode = _usePredecessor ? node.right : node.left;
      }
      nodePath.add(currentNode);
    }

    if (currentNode is ThreeNode<T>) {
      return ReplacePayload(nodePath, _usePredecessor ? currentNode.rightValue : currentNode.leftValue);
    } else if (currentNode is TwoNode<T>) {
      return ReplacePayload(nodePath, currentNode.value);
    }
    throw Exception('Traversing unsupported node ${node.runtimeType} when finding  ${_usePredecessor ? 'predecessor' : 'successor'}.');
  }

  List<Node<T>> _findNodePath(Node<T> node, T value) {
    bool isFound = false;
    bool isInit = true;
    final path = <Node<T>>[];
    var currentNode = node;
    while (!isFound && currentNode.hasChildren) {
      if (isInit) {
        isInit = false;
        currentNode = node;
      } else {
        // Traverse Case
        if (currentNode is ThreeNode<T>) {
          if (value.compareTo(currentNode.leftValue) < 0) {
            currentNode = currentNode.left;
          } else if (value.compareTo(currentNode.rightValue) > 0) {
            currentNode = currentNode.right;
          } else {
            currentNode = currentNode.middle;
          }
        } else if (currentNode is TwoNode<T>) {
          currentNode = value.compareTo(currentNode.value) <= 0 ? currentNode.left : currentNode.right;
        }
      }
      path.add(currentNode);
      print('currentNode: $currentNode');

      if ((currentNode is ThreeNode<T> && (currentNode.leftValue == value || currentNode.rightValue == value)) || (currentNode is TwoNode<T> && currentNode.value == value)) {
        isFound = true;
        continue;
      }
    }
    return isFound ? path : [];
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
          }
      );
    } else if (parent is ThreeNode<T>) {
      final lessThanLeftValue = parent.leftValue.compareTo(newValue) > 0;
      final greaterThanRightValue = parent.rightValue.compareTo(newValue) < 0;

      childNode = ChildUpdate(
        childKey: lessThanLeftValue ? ChildKey.left : greaterThanRightValue ? ChildKey.right : ChildKey.middle,
        nextChildNode: lessThanLeftValue ? parent.left : greaterThanRightValue ? parent.right : parent.middle,
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
}

typedef ChildUpdater<T extends Comparable> = void Function(Node<T> newNode);

class ChildUpdate<T extends Comparable> {
  ChildUpdate({required this.nextChildNode, required this.updateChild, required this.childKey});
  final Node<T> nextChildNode;
  final ChildUpdater<T> updateChild;
  final ChildKey childKey;
}



class ReplacePayload<T extends Comparable> {
  ReplacePayload(this.path, this.replaceValue);
  List<Node<T>> path;
  Node<T> get node => path.last;
  T replaceValue;
}



Iterable<Node<T>> mergeNodePaths<T extends Comparable>(Iterable<Node<T>> a, Iterable<Node<T>> b) => [...a, ...b];
