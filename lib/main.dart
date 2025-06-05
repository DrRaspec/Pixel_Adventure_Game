import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen(); // Sets the app to be full-screen
  Flame.device.setLandscape(); // Sets the app orientation to landscape only

  PixelAdventure game = PixelAdventure();
  // kDebugMode make the game can be hot reload and no need to restart
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
