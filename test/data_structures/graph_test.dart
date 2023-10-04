import 'package:DDSA/data_structures/graphs/generic_graph.dart';
import 'package:test/test.dart';

void main() {
  group('graph', () {
    group('isBipartite', () {
      group('is true when.', () {
        test('graph is empty.', () {
          final graph = Graph<int>.fromNodes([]);
          expect(Graph.isBipartite(graph), true);
        });
        test('graph has no same color neighbors.', () {
          final node1 = Node<int>(1);
          final node2 = Node<int>(2);
          final node3 = Node<int>(3);
          final node4 = Node<int>(4);

          node1.edges = [node2];
          node2.edges = [node1, node3];
          node3.edges = [node2, node4];
          node4.edges = [node3];
          final graph = Graph<int>.fromNodes([node1, node2, node3, node4]);
          expect(Graph.isBipartite(graph), true);
        });
      });
      group('is false when', () {
        test('graph has same color neighbors.', () {
          final node1 = Node<int>(1);
          final node2 = Node<int>(2);
          final node3 = Node<int>(3);
          final node4 = Node<int>(4);

          node1.edges = [node2];
          node2.edges = [node1, node3];
          node3.edges = [node2, node4, node1];
          node4.edges = [node3, node1];
          node1.edges.add(node4);

          final graph = Graph<int>.fromNodes([node1, node2, node3, node4]);
          expect(Graph.isBipartite(graph), false);
        });
      });
    });
  });
}
