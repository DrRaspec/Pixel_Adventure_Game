import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/game/characters/player.dart';

class Level extends World {
  Level({required this.levelName});
  final String levelName;

  late TiledComponent level;

  // like oninit
  @override
  FutureOr<void> onLoad() async {
    // vector 2 all (16) is stand for the game pixel we used to design
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointPlayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointPlayer == null) {
      return;
    }
    for (var spawnPoint in spawnPointPlayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(
            character: 'Pink Man',
            position: Vector2(spawnPoint.x, spawnPoint.y),
          );
          add(player);
          break;
        default:
      }
    }

    // add(Player(character: 'Ninja Frog'));

    return super.onLoad();
  }
}
