// the extends of class is depend on the animation we use on the character
// so our character can do stuff like running, idle, jumping and falling
// it best practice to use is spite animation

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, KeyboardHandler {
  Player({super.position, this.character = 'Ninja Frog'});
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double jumpForce = 460;
  final double _terminalVelocity = 300;

  double horizontalMove = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // dt stand for delta type
    // dt allow us to check how many times our game has been update
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollsions();
    _applyGravity(dt);
    _cehckVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMove = 0;

    final isLeftKeyPress =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPress =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMove += isLeftKeyPress ? -1 : 0;
    horizontalMove += isRightKeyPress ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
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
    velocity.x = horizontalMove * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _checkHorizontalCollsions() {
    for (var block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          } else if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }
  
  void _cehckVerticalCollisions() {
    for (var block in collisionBlocks) {
      if(block.isPlatform) {
        
      }
    }
  }
}
