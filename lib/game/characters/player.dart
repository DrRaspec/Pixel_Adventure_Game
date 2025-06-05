// the extends of class is depend on the animation we use on the character
// so our character can do stuff like running, idle, jumping and falling
// it best practice to use is spite animation

import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure> {
  Player({required this.character, super.position});
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;
  bool isFacingRight = true;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // dt stand for delta type
    // dt allow us to check how many times our game has been update
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation(
      state: 'Idle',
      amount: 11,
      stepTime: stepTime,
      pixel: 32,
    );

    runningAnimation = _spriteAnimation(
      state: 'Run',
      amount: 12,
      stepTime: stepTime,
      pixel: 32,
    );

    // List of all animation
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation({
    required String state,
    required int amount,
    required double stepTime,
    double pixel = 32,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(pixel),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;

    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(dirX, 0);
    position += velocity * dt;
  }
}
