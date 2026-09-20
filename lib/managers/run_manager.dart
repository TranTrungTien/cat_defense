import 'dart:math';

enum NodeType { battle, elite, shop, mystery, rescue, workshop, boss }

class RunNode {
  final int id;
  final NodeType type;
  final int depth;
  final List<int> nextNodes;
  bool isAccessible = false;
  bool isCompleted = false;

  RunNode({
    required this.id,
    required this.type,
    required this.depth,
    this.nextNodes = const [],
  });
}

class RunManager {
  static final RunManager _instance = RunManager._internal();
  static RunManager get instance => _instance;
  RunManager._internal();

  int currentBiome = 1;
  int currentDepth = 0;
  List<RunNode> map = [];
  int currentNodeId = -1;

  final List<String> activePerks = [];
  final List<String> collectedRelics = [];
  final List<String> activeModifiers = [];
  int seed = 0;

  void startNewRun({int? seed}) {
    this.seed = seed ?? Random().nextInt(1000000);
    currentBiome = 1;
    currentDepth = 0;
    activePerks.clear();
    collectedRelics.clear();
    activeModifiers.clear();
    _generateMap();
    currentNodeId = -1;
    // Make first layer accessible
    for (var node in map.where((n) => n.depth == 0)) {
      node.isAccessible = true;
    }
  }

  void _generateMap() {
    map.clear();
    final random = Random(seed);
    int idCounter = 0;

    // Simple vertical map generation
    final int mapDepth = 6; // 6 layers + boss
    final List<List<RunNode>> layers = [];

    for (int d = 0; d < mapDepth; d++) {
      int nodeCount = d == 0 ? 3 : (random.nextInt(2) + 2);
      List<RunNode> layer = [];
      for (int i = 0; i < nodeCount; i++) {
        NodeType type = NodeType.battle;
        if (d > 0) {
          double r = random.nextDouble();
          if (r < 0.15) {
            type = NodeType.shop;
          } else if (r < 0.3) {
            type = NodeType.elite;
          } else if (r < 0.45) {
            type = NodeType.mystery;
          } else if (r < 0.6) {
            type = NodeType.rescue;
          }
        }
        layer.add(RunNode(id: idCounter++, type: type, depth: d));
      }
      layers.add(layer);
      map.addAll(layer);
    }

    // Add Boss node
    final bossNode = RunNode(id: idCounter++, type: NodeType.boss, depth: mapDepth);
    map.add(bossNode);
    layers.add([bossNode]);

    // Connect layers
    for (int d = 0; d < layers.length - 1; d++) {
      for (var node in layers[d]) {
        // Connect to 1-2 random nodes in next layer
        final nextLayer = layers[d + 1];
        final nextCount = random.nextInt(min(2, nextLayer.length)) + 1;
        final nexts = List.generate(nextLayer.length, (i) => i)..shuffle();
        final selected = nexts.take(nextCount).map((i) => nextLayer[i].id).toList();

        // Ensure every node in next layer is reachable if possible
        // (Simple implementation: just connect to first available if nextLayer is empty)
        node.nextNodes.addAll(selected);
      }
    }

    // Ensure connectivity: check if any node in d+1 is not connected from d
    for (int d = 1; d < layers.length; d++) {
      for (var nextNode in layers[d]) {
        bool hasParent = layers[d-1].any((p) => p.nextNodes.contains(nextNode.id));
        if (!hasParent) {
          layers[d-1][random.nextInt(layers[d-1].length)].nextNodes.add(nextNode.id);
        }
      }
    }
  }

  void completeNode(int id) {
    final node = map.firstWhere((n) => n.id == id);
    node.isCompleted = true;
    node.isAccessible = false;
    currentNodeId = id;
    currentDepth = node.depth;

    // Unlock next nodes
    for (var nextId in node.nextNodes) {
      map.firstWhere((n) => n.id == nextId).isAccessible = true;
    }

    // Lock other nodes in current depth that weren't picked
    for (var other in map.where((n) => n.depth == node.depth && n.id != id)) {
      other.isAccessible = false;
    }
  }
}
