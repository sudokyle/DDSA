
abstract class Node<T extends Comparable> {
  bool get hasChildren;
  Iterable<Node<T>> get children;
}


// Insertion + Tree balancing Algorithm
// Step 1: traverse to find insertionNode
// Step 2: calculate new Node for insertionNode
// Step 3: promote / update tree accordingly


Node<T> leafNodeBuilder<T extends Comparable>(T newValue, {Node<T>? insertionNode}) {
  late final newNode;

  if (insertionNode == null) {
    newNode = TwoNode.createLeaf(newValue);
  } else if (insertionNode is TwoNode<T>) {
    final value = insertionNode.value;
    final isNewLeft = insertionNode.value.compareTo(newValue) > 0;
    newNode = ThreeNode.createLeaf((isNewLeft ? newValue : value), isNewLeft ? value : newValue);
  } else if (insertionNode is ThreeNode<T>) {
    final leftValue = insertionNode.leftValue;
    final rightValue = insertionNode.rightValue;
    final isNewLeft = leftValue.compareTo(newValue) > 0;
    final isNewRight = rightValue.compareTo(newValue) < 0;

    newNode = isNewLeft ? FourNode.createLeaf(newValue, leftValue, rightValue) :
      isNewRight ? FourNode.createLeaf(leftValue, rightValue, newValue) :
      FourNode.createLeaf(leftValue, newValue, rightValue);
  }

  return newNode;
}

class ZeroNode<T extends Comparable> extends Node<T> {
  @override
  bool get hasChildren => false;

  @override
  Iterable<Node<T>> get children => [];


}

class TwoNode<T extends Comparable> extends Node<T> {
  TwoNode._(this.value, this._left, this._right);

  final T value;
  Node<T>? _left;
  Node<T>? _right;

  factory TwoNode.createLeaf(T value) {
    return TwoNode._(value, null, null);
  }

  factory TwoNode.create(T value, Node<T> leftChild, Node<T> rightChild) {
    return TwoNode._(value, leftChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left, _right].whereType<Node<T>>();

  Node<T> get left => _left!;
  Node<T> get right => _right!;

  set left(Node<T> newNode) => _left = newNode;
  set right(Node<T> newNode) => _right = newNode;

  @override
  String toString() {
    return '($value)';
  }
}

class ThreeNode<T extends Comparable> extends Node<T> {
  ThreeNode._(this.leftValue, this.rightValue, this._left, this._middle, this._right);

  final T leftValue;
  final T rightValue;
  Node<T>? _left;
  Node<T>? _middle;
  Node<T>? _right;

  factory ThreeNode.createLeaf(T leftValue, T rightValue) {
    return ThreeNode._(leftValue, rightValue, null, null, null);
  }

  factory ThreeNode.create(T leftValue, T rightValue, Node<T> leftChild, Node<T> middleChild, Node<T> rightChild) {
    return ThreeNode._(leftValue, rightValue, leftChild, middleChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _middle != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left, _middle , _right].whereType<Node<T>>();

  Node<T> get left => _left!;
  Node<T> get middle => _middle!;
  Node<T> get right => _right!;

  set left(Node<T> newNode) => _left = newNode;
  set middle(Node<T> newNode) => _middle = newNode;
  set right(Node<T> newNode) => _right = newNode;

  @override
  String toString() {
    return '($leftValue, $rightValue)';
  }
}

class FourNode<T extends Comparable> extends Node<T> {
  FourNode._(this.leftValue, this.middleValue, this.rightValue, this._left, this._middleLeft, this._middleRight, this._right);

  final T leftValue;
  final T middleValue;
  final T rightValue;
  final Node<T>? _left;
  final Node<T>? _middleLeft;
  final Node<T>? _middleRight;
  final Node<T>? _right;

  factory FourNode.createLeaf(T leftValue, T middleValue, T rightValue) {
    return FourNode._(leftValue, middleValue, rightValue, null, null, null, null);
  }

  factory FourNode.create(T leftValue, T middleValue, T rightValue, Node<T> leftChild, Node<T> middleLeftChild, Node<T> middleRightChild, Node<T> rightChild) {
    return FourNode._(leftValue, middleValue, rightValue, leftChild, middleLeftChild, middleRightChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _middleLeft != null && _middleRight != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left, _middleLeft, _middleRight, _right].whereType<Node<T>>();

  Node<T> get left => _left!;
  Node<T> get middleLeft => _middleLeft!;
  Node<T> get middleRight => _middleRight!;
  Node<T> get right => _right!;

  @override
  String toString() {
    return '($leftValue, $middleValue , $rightValue)';
  }
}


