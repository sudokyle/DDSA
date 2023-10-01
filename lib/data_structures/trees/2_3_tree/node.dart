enum ChildKey {left, middle, right}

abstract class Node<T extends Comparable> {
  bool get hasChildren;
  Iterable<Node<T>> get children;
  Node<T>? siblingOf(Node<T> child);
  ChildKey? relationship(Node<T> child);
  void replace(Node<T> child, Node<T> replaceWith);
}

mixin TwoChildNode<T extends Comparable> on Node<T> {
  Node<T> get left;
  Node<T> get right;
  set left(Node<T> newNode);
  set right(Node<T> newNode);
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

class HoleNode<T extends Comparable> extends Node<T> {
  HoleNode._(this._child);

  Node<T>? _child;

  factory HoleNode.createLeaf() => HoleNode._(null);
  factory HoleNode.create(Node<T> child) => HoleNode._(child);

  @override
  bool get hasChildren => _child != null;

  @override
  Iterable<Node<T>> get children => [_child].whereType<Node<T>>();

  Node<T> get child => _child as Node<T>;
  Node<T>? get maybeChild => _child;

  set child(Node<T> newNode) => _child = newNode;

  @override
  Node<T>? siblingOf(Node<T> child) => throw UnsupportedError('Function not supported with HoleNode.');

  @override
  ChildKey? relationship(Node<T> child) => throw UnsupportedError('Function not supported with HoleNode.');

  @override
  void replace(Node<T> child, Node<T> replaceWith) {
    if (this.child == child) {
      child = replaceWith;
    }
  }

  @override
  String toString() => '(HOLE)';
}

class ZeroNode<T extends Comparable> extends Node<T> {
  @override
  bool get hasChildren => false;

  @override
  Iterable<Node<T>> get children => [];

  @override
  Node<T>? siblingOf(Node<T> child) => throw UnsupportedError('Function not supported with ZeroNode.');

  @override
  ChildKey? relationship(Node<T> child) => throw UnsupportedError('Function not supported with ZeroNode.');

  @override
  void replace(Node<T> child, Node<T> replaceWith) => throw UnsupportedError('Function not supported with ZeroNode.');
}

class TwoNode<T extends Comparable> extends Node<T> with TwoChildNode<T> {
  TwoNode._(this._value, this._left, this._right);

  T _value;
  Node<T>? _left;
  Node<T>? _right;

  factory TwoNode.createLeaf(T value) {
    return TwoNode._(value, null, null);
  }

  factory TwoNode.create(T value, Node<T> leftChild, Node<T> rightChild) {
    return TwoNode._(value, leftChild, rightChild);
  }

  factory TwoNode.createNullable(T leftValue, Node<T>? leftChild, Node<T>? rightChild) {
    return TwoNode._(leftValue, leftChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left as Node<T>, _right as Node<T>].whereType<Node<T>>();

  T get value => _value;
  Node<T> get left => _left as Node<T>;
  Node<T> get right => _right as Node<T>;

  Node<T>? get maybeLeft => _left;
  Node<T>? get maybeRight => _right;

  set value(T value) => _value = value;
  set left(Node<T> newNode) => _left = newNode;
  set right(Node<T> newNode) => _right = newNode;

  @override
  Node<T>? siblingOf(Node<T> child) {
    if (left == child) return right;
    if (right == child) return left;
    return null;
  }

  @override
  ChildKey? relationship(Node<T> child) {
    if (child == left) return ChildKey.left;
    if (child == right) return ChildKey.right;
    return null;
  }

  @override
  void replace(Node<T> child, Node<T> replaceWith) {
    if (left == child) {
      left = replaceWith;
    } else if (right == child) {
      right = replaceWith;
    }
  }

  @override
  String toString() {
    return '($value)';
  }
}

class ThreeNode<T extends Comparable> extends Node<T> with TwoChildNode<T> {
  ThreeNode._(this._leftValue, this._rightValue, this._left, this._middle, this._right);

  T _leftValue;
  T _rightValue;
  Node<T>? _left;
  Node<T>? _middle;
  Node<T>? _right;

  factory ThreeNode.createLeaf(T leftValue, T rightValue) {
    return ThreeNode._(leftValue, rightValue, null, null, null);
  }

  factory ThreeNode.create(T leftValue, T rightValue, Node<T> leftChild, Node<T> middleChild, Node<T> rightChild) {
    return ThreeNode._(leftValue, rightValue, leftChild, middleChild, rightChild);
  }

  factory ThreeNode.createNullable(T leftValue, T rightValue, Node<T>? leftChild, Node<T>? middleChild, Node<T>? rightChild) {
    return ThreeNode._(leftValue, rightValue, leftChild, middleChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _middle != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left as Node<T>, _middle as Node<T>, _right as Node<T>].whereType<Node<T>>();

  T get leftValue => _leftValue;
  T get rightValue => _rightValue;
  Node<T> get left => _left as Node<T>;
  Node<T> get middle => _middle as Node<T>;
  Node<T> get right => _right as Node<T>;

  Node<T>? get maybeLeft => _left;
  Node<T>? get maybeMiddle => _middle;
  Node<T>? get maybeRight => _right;

  set leftValue(T value) => _leftValue = value;
  set rightValue(T value) => _rightValue = value;

  set left(Node<T> newNode) => _left = newNode;
  set middle(Node<T> newNode) => _middle = newNode;
  set right(Node<T> newNode) => _right = newNode;

  @override
  Node<T>? siblingOf(Node<T> child) {
    if (left == child) return right;
    if (right == child) return left;
    if (middle == child) return left; // we tend left when dealing with the middle
    return null;
  }

  @override
  ChildKey? relationship(Node<T> child) {
    if (child == left) return ChildKey.left;
    if (child == right) return ChildKey.right;
    if (middle == child) return ChildKey.middle;
    return null;
  }

  @override
  void replace(Node<T> child, Node<T> replaceWith) {
    if (left == child) {
      left = replaceWith;
    } else if (right == child) {
      right = replaceWith;
    } else if (middle == child) {
      middle = replaceWith;
    }
  }

  @override
  String toString() {
    return '($_leftValue, $_rightValue)';
  }
}

class FourNode<T extends Comparable> extends Node<T> {
  FourNode._(this.leftValue, this.middleValue, this.rightValue, this._left, this._middleLeft, this._middleRight, this._right);

  final T leftValue;
  final T middleValue;
  final T rightValue;
  Node<T>? _left;
  Node<T>? _middleLeft;
  Node<T>? _middleRight;
  Node<T>? _right;

  factory FourNode.createLeaf(T leftValue, T middleValue, T rightValue) {
    return FourNode._(leftValue, middleValue, rightValue, null, null, null, null);
  }

  factory FourNode.create(T leftValue, T middleValue, T rightValue, Node<T> leftChild, Node<T> middleLeftChild, Node<T> middleRightChild, Node<T> rightChild) {
    return FourNode._(leftValue, middleValue, rightValue, leftChild, middleLeftChild, middleRightChild, rightChild);
  }

  @override
  bool get hasChildren => _left != null && _middleLeft != null && _middleRight != null && _right != null;

  @override
  Iterable<Node<T>> get children => [_left as Node<T>, _middleLeft as Node<T>, _middleRight as Node<T>, _right as Node<T>].whereType<Node<T>>();

  Node<T> get left => _left as Node<T>;
  Node<T> get middleLeft => _middleLeft as Node<T>;
  Node<T> get middleRight => _middleRight as Node<T>;
  Node<T> get right => _right as Node<T>;

  set left(Node<T> newNode) => _left = newNode;
  set middleLeft(Node<T> newNode) => _middleLeft = newNode;
  set middleRight(Node<T> newNode) => _middleRight = newNode;
  set right(Node<T> newNode) => _right = newNode;

  // todo: update enums and stuff to better support maybe? though 4Node is more transient
  @override
  Node<T>? siblingOf(Node<T> child) {
    if (left == child) return right;
    if (right == child) return left;
    if (middleLeft == child) return left; // we tend left when dealing with the middle
    if (middleRight == right) return left; // we tend left when dealing with the middle
    return null;
  }

  // todo: update enums and stuff to better support maybe? though 4Node is more transient
  @override
  ChildKey? relationship(Node<T> child) {
    if (child == left) return ChildKey.left;
    if (child == right) return ChildKey.right;
    if (middleLeft == child) return ChildKey.middle;
    if (middleRight == child) return ChildKey.middle;
    return null;
  }

  @override
  void replace(Node<T> child, Node<T> replaceWith) {
    if (left == child) {
      left = replaceWith;
    } else if (right == child) {
      right = replaceWith;
    } else if (middleLeft == child) {
      middleLeft = replaceWith;
    } else if (middleRight == child) {
      middleRight = replaceWith;
    }

  }

  @override
  String toString() {
    return '($leftValue, $middleValue , $rightValue)';
  }
}
