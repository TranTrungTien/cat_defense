import 'package:flame/components.dart';

class LevelNodeDef {
  final int level;
  final Vector2 position;
  LevelNodeDef(this.level, this.position);
}

class LevelMapLayout {
  static const double mapWidth = 1920;
  static const double mapHeight = 1080;

  static final List<LevelNodeDef> nodes = [
    LevelNodeDef(1, Vector2(300, 800)),
    LevelNodeDef(2, Vector2(300, 600)),
    LevelNodeDef(3, Vector2(500, 600)),
    LevelNodeDef(4, Vector2(700, 600)),
    LevelNodeDef(5, Vector2(700, 400)),
    LevelNodeDef(6, Vector2(500, 400)),
    LevelNodeDef(7, Vector2(300, 400)),
    LevelNodeDef(8, Vector2(300, 200)),
    LevelNodeDef(9, Vector2(500, 200)),
    LevelNodeDef(10, Vector2(700, 200)),
    LevelNodeDef(11, Vector2(900, 200)),
    LevelNodeDef(12, Vector2(1100, 200)),
    LevelNodeDef(13, Vector2(1300, 200)),
    LevelNodeDef(14, Vector2(1300, 400)),
    LevelNodeDef(15, Vector2(1300, 600)),
  ];
}
