import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_space_shooter/constants.dart';
import 'package:flame_space_shooter/player.dart';
import 'package:flame_space_shooter/projectile.dart';
import 'package:flame_space_shooter/space_shooter_game.dart';

class Enemy extends RiveComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  int damage;
  int health = 1;
  final _fireCooloff = Stopwatch();
  int value = 100;
  Artboard artboard;
  late final StateMachineController controller;

  Enemy(Vector2 position, this.damage, this.artboard)
      : super(
            size: Vector2(enemyWidth, enemyHeight),
            artboard: artboard,
            position: Vector2(position.x, position.y));

  @override
  void update(double dt) {
    super.update(dt);
    artboard.advance(dt);

    position += Vector2(goLeft * enemySpeed, 0) * dt;
    if (position.x < -100) {
      removeFromParent();
    }
    fire();
  }

  @override
  void onLoad() {
    controller = StateMachineController.fromArtboard(artboard, 'enemy')!;
    artboard.addController(controller);

    add(RectangleHitbox());
    _fireCooloff.start();
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Projectile && other.isPlayerProjectile) {
      health -= other.damage;
      if (health <= 0) {
        removeFromParent();
      }
      gameRef.score += value;
      gameRef.remove(other);
    }
    if (other is Player) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  fire() {
    if (_fireCooloff.elapsedMilliseconds < 1500 ||
        position.x >= gameRef.size.x ||
        position.x <= -size.x) return;

    final projectile = Projectile(Vector2(position.x, position.y + size.y / 2),
        1, goLeft, false, gameRef.enemyProjectileArtboard);
    gameRef.add(projectile);

    _fireCooloff.reset();
  }
}
