import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_space_shooter/constants.dart';
import 'package:flame_space_shooter/space_shooter_game.dart';

class Projectile extends RiveComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  int damage;
  double direction;
  bool isPlayerProjectile;
  Artboard artboard;

  Projectile(Vector2 position, this.damage, this.direction,
      this.isPlayerProjectile, this.artboard)
      : super(
            size: Vector2(projectileWidth, projectileHeight),
            position: position,
            artboard: artboard);

  @override
  void update(double dt) {
    super.update(dt);
    artboard.advance(dt);

    position += Vector2(direction * projectileVelocity, 0) * dt;
    if (position.x > gameRef.size.x + 10 || position.x < -50) {
      removeFromParent();
    }
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Projectile) {
      removeFromParent();
    }
  }
}
