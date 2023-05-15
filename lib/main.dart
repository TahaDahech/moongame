import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:moongame/components/screens/my_game.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(GameWidget(game: MyGame()));
}
