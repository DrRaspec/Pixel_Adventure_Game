import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/game/levels/level.dart';

class PixelAdventure extends FlameGame {
  // late final CameraComponent cam;
  @override
  Color backgroundColor() => const Color(0xff211F30);

  @override
  FutureOr<void> onLoad() async {
    // Initialize the world with Level
    world = Level(levelName: 'Level-02');

    // load all images into cache
    await images.loadAllImages();
    // No need to add world and manually it will be add automatic not like in the older version
    // built-in camera system with the HasCamera mixin (which FlameGame includes by default).
    // cam = CameraComponent.withFixedResolution(
    //   world: world,
    //   width: 640,
    //   height: 368,
    // );

    camera.viewport = FixedResolutionViewport(resolution: Vector2(640, 368));
    camera.viewfinder.anchor = Anchor.topLeft;

    return super.onLoad();
  }
}
