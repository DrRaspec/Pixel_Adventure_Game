import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/core/assets.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  // late final CameraComponent cam;

  final player = Player(character: 'Virtual Guy');
  late final JoystickComponent joystick;
  bool showJoystick = true;

  @override
  Color backgroundColor() => const Color(0xff211F30);

  @override
  FutureOr<void> onLoad() async {
    // Initialize the world with Level
    world = Level(levelName: 'Level-01', player: player);

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

    if (showJoystick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache(GameAssets.knob))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache(GameAssets.joystickBackground)),
      ),
      // knobRadius: 64, // knob radius is use to make how much hub can spread out of background
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      position: Vector2(100, 300),
    );

    // in newer version you can't just use add(joystick) like this
    // this will make the joy stick display behind the world
    // add(joystick);
    // you must add to camera view port to make it display infront of world or map
    camera.viewport.add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMove = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMove = 1;
        break;
      default:
        player.horizontalMove = 0;
        break;
    }
  }
}
