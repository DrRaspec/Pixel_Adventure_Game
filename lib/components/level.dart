import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  Level({required this.levelName, required this.player});
  final String levelName;
  final Player player;

  late TiledComponent level;

  List<CollisionBlock> collisionBlocks = [];

  // like oninit
  @override
  FutureOr<void> onLoad() async {
    // vector 2 all (16) is stand for the game pixel we used to design
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointPlayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointPlayer != null) {
      for (var spawnPoint in spawnPointPlayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (var collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platforms':
            final platform = CollisionBlock(
              // get the position of that object from tile file
              position: Vector2(collision.x, collision.y),
              // get the size of that object from tile file
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            // add is a feature that allow flame to at stuff to screen
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }
}
