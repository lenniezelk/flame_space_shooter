import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_space_shooter/constants.dart';
import 'package:flame_space_shooter/enemy.dart';
import 'package:flame_space_shooter/projectile.dart';
import 'package:flame_space_shooter/space_shooter_game.dart';

class Player extends RiveComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  int health = 3;
  late final StateMachineController controller;

  Player(Artboard artboard)
      : super(artboard: artboard, size: Vector2(playerWidth, playerHeight));

  @override
  FutureOr<void> onLoad() {
    controller = StateMachineController.fromArtboard(artboard, 'hero')!;
    artboard.addController(controller);

    position = Vector2(xPos, (gameRef.size.y / 2) - playerWidth / 2);
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    artboard.advance(dt);

    if (gameRef.isGameOver) {
      return;
    }

    if (position.y <= 0) {
      position = Vector2(xPos, 0);
    } else if (position.y >= gameRef.size.y - size.y) {
      position = Vector2(xPos, gameRef.size.y - size.y);
    }
    position += velocity * dt;
  }

  void moveUp() {
    velocity = Vector2(0, -playerSpeed);
  }

  void moveDown() {
    velocity = Vector2(0, playerSpeed);
  }

  fire() {
    if (gameRef.isGameOver) {
      return;
    }

    final projectile = Projectile(
        Vector2(xPos + playerWidth, position.y + playerHeight / 2),
        1,
        goRight,
        true,
        gameRef.playerProjectileArtboard);

    gameRef.add(projectile);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (gameRef.isGameOver) {
      return;
    }

    if (other is Enemy) {
      _takeDamage();
    } else if (other is Projectile && !other.isPlayerProjectile) {
      _takeDamage();
      gameRef.remove(other);
    }

    super.onCollision(intersectionPoints, other);
  }

  _takeDamage() {
    // add(ColorEffect(
    //     const Color.fromARGB(255, 255, 255, 255),
    //     const Offset(0, 0.8),
    //     EffectController(duration: 0.05, reverseDuration: 0.05)));
    // add(OpacityEffect.to(
    //     0.7, EffectController(duration: 0.05, reverseDuration: 0.05)));
    health -= 1;
    if (health <= 0) {
      gameRef.isGameOver = true;
    }
  }
}
