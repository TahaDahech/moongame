import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapDetector {
  SpriteComponent person = SpriteComponent();
  SpriteComponent person2 = SpriteComponent();
  SpriteComponent knobSprite = SpriteComponent();
  SpriteComponent joybgSprite = SpriteComponent();

  late JoystickComponent joystick;
  final double charSize = 100.0;
  final double jumpHeight = 200.0;
  bool isJumping = false;
  double jumpSpeed = 400.0;
  double gravity = 800.0;

  @override
  Future<void> onLoad() async {
    final screenWidth = size[0];
    final screenHeight = size[1];

    final roadSize = screenHeight / 6;

    print('loading game assets');
    super.onLoad();

    //person
    person.sprite = await loadSprite('person.png');
    person.size = Vector2(charSize, charSize);
    person.y = screenHeight / 2 - charSize / 2;
    person.x = screenWidth / 6 - charSize / 6;
    add(person);

    //joystick
    knobSprite.sprite = await loadSprite('knob0.png');
    knobSprite.size = Vector2(40, 40);
    joybgSprite.sprite = await loadSprite('bg0.png');
    joybgSprite.size = Vector2(80, 80);
    joystick = JoystickComponent(
      size: 50,
      margin: EdgeInsets.only(top: 300.0, left: 50.0),
      knob: knobSprite,
      background: joybgSprite,
    );
    joystick.position = Vector2(0, 0);
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final screenHeight = size[1];
    final screenWidth = size[0];
    final roadSize = screenHeight / 6;

    final backgroundSpeed = 100;
    final movement = backgroundSpeed * dt;
// Start the jump if the joystick is being dragged up
    if (joystick.delta.y < 0 && !isJumping) {
      isJumping = true;
    }

    if (isJumping) {
      person.y -= jumpSpeed * dt;
      jumpSpeed -= gravity * dt;
      // Stop the jump if the person has landed
      if (person.y >= screenHeight - charSize - roadSize) {
        person.y = screenHeight - charSize - roadSize;
        isJumping = false;
        jumpSpeed = 400.0;
      }
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    // Start the jump if the person is not already jumping
    if (!isJumping) {
      isJumping = true;
    }
  }
}
