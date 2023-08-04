import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_space_shooter/space_shooter_game.dart';
import "package:flutter/material.dart";

const gameOverTextStyle = TextStyle(
  color: Color.fromARGB(255, 225, 25, 102),
  fontSize: 50,
  fontWeight: FontWeight.bold,
);

const restartTextStyle = TextStyle(
  color: Color.fromARGB(255, 225, 25, 102),
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

class GameOverPanel extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  GameOverPanel() : super(priority: 10000);

  final gameOverText = TextComponent(
    text: 'Game Over',
    textRenderer: TextPaint(style: gameOverTextStyle),
  );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(gameRef.size.x / 2 - gameOverText.size.x / 2,
        gameRef.size.y / 2 - gameOverText.size.y / 2);

    add(gameOverText);
    add(ResetText()..position = Vector2(10, gameOverText.height + 20));

    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (!gameRef.isGameOver) {
      return;
    }

    super.renderTree(canvas);
  }
}

class ResetText extends TextComponent {
  ResetText()
      : super(
          text: 'Press "R" Restart',
          textRenderer: TextPaint(style: restartTextStyle),
        );
}
