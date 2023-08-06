import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_space_shooter/space_shooter_game.dart';
import 'package:flutter/material.dart';

class Bg extends RiveComponent with HasGameRef<SpaceShooterGame> {
  late final StateMachineController controller;
  Bg(Artboard artboard)
      : super(artboard: artboard, fit: BoxFit.cover, position: Vector2(0, 0));

  @override
  FutureOr<void> onLoad() {
    size = Vector2(gameRef.size.x, gameRef.size.y);
    controller = StateMachineController.fromArtboard(artboard, 'bg')!;
    artboard.addController(controller);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    artboard.advance(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
