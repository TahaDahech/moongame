import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapDetector, WidgetsBindingObserver {
  @override
  void onAttach() {
    super.onAttach();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onDetach() {
    super.onDetach();
    WidgetsBinding.instance.removeObserver(this);
  }

  SpriteComponent person = SpriteComponent();
  SpriteComponent person2 = SpriteComponent();
  SpriteComponent background1 = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  SpriteComponent moon1 = SpriteComponent();
  SpriteComponent moon2 = SpriteComponent();
  SpriteComponent obstacle1 = SpriteComponent();

  SpriteComponent knobSprite = SpriteComponent();
  SpriteComponent joybgSprite = SpriteComponent();

  late JoystickComponent joystick;

  final double charSize = 100.0;
  final double jumpHeight = 200.0;
  bool isJumping = false;
  bool isUp = true;
  bool isMiddle = true;
  bool isDown = true;
  double jumpSpeed = 400.0;
  double gravity = 800.0;
  bool lost = false;

  double moon1Timer = 16;
  double moon2Timer = 27;

  @override
  Future<void> onLoad() async {
    final screenWidth = size[0];
    final screenHeight = size[1];

    final roadSize = screenHeight / 6;

    print('loading game assets');
    super.onLoad();

    //backgrounds (2 backgrounds to loop them)
    background1.sprite = await loadSprite('bg.png');
    background2.sprite = await loadSprite('bg.png');

    background1.size = Vector2(screenWidth, screenHeight);
    background2.size = Vector2(screenWidth, screenHeight);
    background1.position = Vector2(0, 0);
    background2.position = Vector2(screenWidth, 0);
    add(background1);
    add(background2);

    //moons at random time
    moon1.sprite = await loadSprite('planet1.png');
    moon2.sprite = await loadSprite('planet2.png');
    moon1.size = Vector2(200, 200);
    moon2.size = Vector2(200, 200);
    moon1.position = Vector2(screenWidth + 300, 0);
    moon2.position = Vector2(screenWidth - 400, 300);
    add(moon1);
    add(moon2);

    //obstacle
    obstacle1.sprite = await loadSprite('obstacle2.png');
    obstacle1.size = Vector2(charSize / 2, charSize);
    obstacle1.y = screenHeight - charSize - roadSize + 10;
    obstacle1.x = screenWidth;
    // add(obstacle1);

    //person
    person.sprite = await loadSprite('person.png');
    person.size = Vector2(charSize, charSize);
    person.y = screenHeight / 2 - charSize;
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
  Future<void> update(double dt) async {
    super.update(dt);

    final screenHeight = size[1];
    final screenWidth = size[0];

    final roadSize = screenHeight / 6;
    final backgroundSpeed = 100;
    final movement = backgroundSpeed * dt;

    //obstacle mouvement
    if (!lost) {
      obstacle1.x -= movement;

      // If a background goes off-screen, reposition it to the end of the other background

      background1.position.x -= movement;
      background2.position.x -= movement;

      if (background1.position.x + screenWidth < 0) {
        background1.position.x = background2.position.x + screenWidth;
      }
      if (background2.position.x + screenWidth < 0) {
        background2.position.x = background1.position.x + screenWidth;
      }

      // Moons  logic
      moon1.x -= movement;
      moon1Timer -= dt;
      moon2.x -= movement;
      moon2Timer -= dt;
      if (moon1.x + moon1.size.x < 0 && moon1Timer < 0) {
        moon1.x = screenWidth;
        moon1Timer = 30.0;
      }
      if (moon2.x + moon2.size.x < 0 && moon2Timer < 0) {
        moon2.x = screenWidth;
        moon2Timer = 40.0;
      }
    }
    // Use the joystick delta to update the position of the person
    //person.x += joystick.delta.x * 8 * dt;

    // Start the jump if the joystick is being dragged up
    if (joystick.delta.y > 0 && isMiddle) {
      person.y += 100;
      isUp = true;
      isMiddle = false;
      isDown = false;
    } else if (joystick.delta.y > 0 && isDown) {
      person.y = screenHeight / 2;
      isUp = false;
      isMiddle = true;
      isDown = false;
    }

    if (joystick.delta.y < 0 && isMiddle) {
      person.y -= 100;
      isUp = false;
      isMiddle = false;
      isDown = true;
    } else if (joystick.delta.y < 0 && isUp) {
      person.y = screenHeight / 2;
      isUp = false;
      isMiddle = true;
      isDown = false;
    }

    // Check for collision
    if (person.toRect().overlaps(obstacle1.toRect())) {
      //  lost = true;
      // print('Collision detected!');
    }
  }

  double generateRandomDelay() {
    final random = Random();
    return random.nextDouble() * 5; // Random delay between 0 and 5 seconds
  }
}
