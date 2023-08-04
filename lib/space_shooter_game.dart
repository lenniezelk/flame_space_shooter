import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_space_shooter/constants.dart';
import 'package:flame_space_shooter/enemy.dart';
import 'package:flame_space_shooter/game_over.dart';
import 'package:flame_space_shooter/player.dart';
import 'package:flame_space_shooter/projectile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpaceShooterGame extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  late final Player player;
  final _enemyCooloff = Stopwatch();
  int score = 0;
  late final TextComponent lifeText;
  late final TextComponent scoreText;
  bool isGameOver = false;
  final gameOverPanel = GameOverPanel();
  late final Artboard playerArtboard;
  late final Artboard playerProjectileArtboard;
  late final Artboard enemyProjectileArtboard;
  late final Artboard enemyArtboard;

  @override
  Future<void> onLoad() async {
    final spaceShooterAssetFile =
        RiveFile.asset("assets/flame_space_shooter.riv");
    playerArtboard =
        await loadArtboard(spaceShooterAssetFile, artboardName: "hero");
    playerProjectileArtboard = await loadArtboard(spaceShooterAssetFile,
        artboardName: "player_projectile");
    enemyProjectileArtboard = await loadArtboard(spaceShooterAssetFile,
        artboardName: "enemy_projectile");
    enemyArtboard =
        await loadArtboard(spaceShooterAssetFile, artboardName: "enemy");

    player = Player(playerArtboard);
    lifeText = TextComponent(
      text: "Life: ${player.health.toString()}",
    )
      ..x = 20.0
      ..y = 5.0;
    scoreText = TextComponent(
      text: "Score: ${score.toString()}",
    )
      ..x = 20.0 + lifeText.width + 20.0
      ..y = 5.0;

    _enemyCooloff.start();

    add(player);
    add(lifeText);
    add(scoreText);
    add(gameOverPanel);
    add(FpsTextComponent(position: Vector2(0, size.y - 24)));

    children.register<Enemy>();
    children.register<Projectile>();

    return super.onLoad();
  }

  @override
  bool debugMode = false;

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    final isW = keysPressed.contains(LogicalKeyboardKey.keyW);
    final isS = keysPressed.contains(LogicalKeyboardKey.keyS);
    final isX = keysPressed.contains(LogicalKeyboardKey.keyX);
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isR = keysPressed.contains(LogicalKeyboardKey.keyR);
    final goUp = isKeyDown && (isW || isArrowUp);
    final goDown = isKeyDown && (isS || isArrowDown);
    final shouldFire = isKeyDown && isX;
    final shouldRestart = isKeyDown && isR;

    var handled = KeyEventResult.ignored;

    if (goUp) {
      player.moveUp();
      handled = KeyEventResult.handled;
    } else if (goDown) {
      player.moveDown();
      handled = KeyEventResult.handled;
    } else if (shouldFire) {
      player.fire();
      handled = KeyEventResult.handled;
    } else if (shouldRestart) {
      restart();
      handled = KeyEventResult.handled;
    }

    return handled;
  }

  @override
  void onTapUp(TapUpInfo info) {
    player.fire();
  }

  void spawnEnemy() {
    if (_enemyCooloff.elapsedMilliseconds < 1000) return;

    final y = (Random().nextDouble() * size.y).clamp(30.0, size.y - 100.0);
    final enemy = Enemy(Vector2(size.x + 10, y), 1, enemyArtboard);
    add(enemy);

    _enemyCooloff.reset();
  }

  @override
  void update(double dt) {
    super.update(dt);

    spawnEnemy();

    lifeText.text = "Life: ${player.health.toString()}";
    scoreText.text = "Score: ${score.toString()}";
    scoreText.x = 20.0 + lifeText.width + 20.0;
  }

  void restart() {
    score = 0;
    player.health = 3;
    player.position = Vector2(xPos, (size.y / 2) - playerWidth / 2);
    player.velocity = Vector2.zero();

    final enemies = children.query<Enemy>();
    for (final enemy in enemies) {
      enemy.removeFromParent();
    }

    final projectiles = children.query<Projectile>();
    for (final projectile in projectiles) {
      projectile.removeFromParent();
    }

    isGameOver = false;
  }
}
