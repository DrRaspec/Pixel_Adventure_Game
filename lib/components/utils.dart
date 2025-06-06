bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // If flipped (scale.x < 0), shift X position left by playerWidth
  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockHeight && // top < block's bottom
      playerY + playerHeight > blockY && // bottom > block's top
      fixedX < blockX + blockWidth && // left < block's right
      // right > block's left
      fixedX + playerWidth > blockX);
}
