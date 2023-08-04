import 'package:flame/extensions.dart';

const playerSpeed = 300.0;
const xPos = 20.0;
const playerWidth = 100.0;
const playerHeight = 37.4;
const enemyWidth = 60.0;
const enemyHeight = enemyWidth / (461.8 / 971.2);
const projectileWidth = 40.0;
const projectileHeight = 14.22;
const projectileVelocity = 1000.0;
const goLeft = -1.0;
const goRight = 1.0;
const enemySpeed = 150.0;
const enemyColor = Color.fromARGB(255, 190, 234, 16);
final enemyProjectileColor = enemyColor.brighten(0.2);
const playerColor = Color.fromARGB(255, 240, 176, 15);
final playerProjectileColor = playerColor.brighten(0.2);
