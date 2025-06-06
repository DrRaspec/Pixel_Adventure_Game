import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sets the app to be full-screen
  await Flame.device.fullScreen(); 
  // Sets the app orientation to landscape only
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();
  // kDebugMode make the game can be hot reload and no need to restart
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
