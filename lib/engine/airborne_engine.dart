import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/customization.dart';
import '../models/game_models.dart';
import '../models/levels.dart';
import '../services/storage_service.dart';

enum ActiveCharacter { light, heavy }

class AirborneEngine extends ChangeNotifier {
  static const double gravity = 860.0;
  static const double lightRadius = 15.0;
  static const double heavyStandingRadius = 23.0;
  static const double heavySlidingRadius = 14.0;

  late List<AirborneLevelDefinition> _levels;
  late AirborneLevelDefinition level;
  int currentLevelIndex = 0;

  Offset lightPos = Offset.zero;
  Offset lightVel = Offset.zero;
  bool lightGrounded = false;
  bool lightAnchored = false;
  double lightBlitzTimer = 0.0;
  double lightFacing = 1.0;

  Offset heavyPos = Offset.zero;
  Offset heavyVel = Offset.zero;
  bool heavyGrounded = false;
  bool heavyTowing = false;
  double heavyFacing = 1.0;

  double currentTension = 0.0;

  ActiveCharacter activeChar = ActiveCharacter.light;
  bool twoPlayerMode = StorageService.twoPlayerMode;

  double lightMoveInput = 0.0;
  double heavyMoveInput = 0.0;
  bool heavyTowHeld = false;

  Offset? dragAimStart;
  Offset? dragAimCurrent;

  List<EnergyCore> cores = [];
  List<Particle> particles = [];
  double elapsedSeconds = 0.0;
  double animTime = 0.0;
  double shakeIntensity = 0.0;
  String statusBanner = '';
  double bannerTimer = 4.0;

  bool isLevelComplete = false;
  bool isFailed = false;
  String failReason = '';
  int earnedStars = 0;

  Offset camCenter = const Offset(400, 340);

  AirborneEngine({int initialLevelIndex = 0}) {
    _levels = AirborneLevels.buildAll();
    loadLevel(initialLevelIndex);
  }

  void loadLevel(int index) {
    _levels = AirborneLevels.buildAll();
    currentLevelIndex = index.clamp(0, _levels.length - 1);
    level = _levels[currentLevelIndex];

    lightPos = level.lightSpawn;
    lightVel = Offset.zero;
    lightGrounded = true;
    lightAnchored = false;
    lightBlitzTimer = 0.0;
    lightFacing = 1.0;

    heavyPos = level.heavySpawn;
    heavyVel = Offset.zero;
    heavyGrounded = true;
    heavyTowing = false;
    heavyFacing = 1.0;

    currentTension = 0.0;
    activeChar = ActiveCharacter.light;

    lightMoveInput = 0.0;
    heavyMoveInput = 0.0;
    heavyTowHeld = false;
    dragAimStart = null;
    dragAimCurrent = null;

    cores = level.corePositions.map((p) => EnergyCore(p)).toList();
    particles = [];
    elapsedSeconds = 0.0;
    shakeIntensity = 0.0;
    statusBanner = level.hint;
    bannerTimer = 5.0;

    isLevelComplete = false;
    isFailed = false;
    failReason = '';
    earnedStars = 0;

    camCenter = Offset(
      (lightPos.dx + heavyPos.dx) * 0.5 + 160,
      340,
    );
    notifyListeners();
  }

  void resetLevel() => loadLevel(currentLevelIndex);

  void toggleControlMode() {
    twoPlayerMode = !twoPlayerMode;
    StorageService.twoPlayerMode = twoPlayerMode;
    StorageService.save();
    notifyListeners();
  }

  void swapActiveCharacter() {
    activeChar = activeChar == ActiveCharacter.light
        ? ActiveCharacter.heavy
        : ActiveCharacter.light;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Fires Light forward in a high-speed horizontal blitz dart to thread closing security doors!
  void fireLightBlitz() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) lightAnchored = false;
    lightBlitzTimer = 0.85;
    lightVel = Offset(lightFacing * 680.0, -135.0);
    lightGrounded = false;
    _spawnBurst(lightPos, lightColor, 16);
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  /// Airborne Anchor Catch: locks Light onto nearest Catch Pad (or ground/airborne clamp) past the door!
  void catchAnchor() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) {
      lightAnchored = false;
      _showBanner('Anchor Catch released — ready for next door!');
      notifyListeners();
      return;
    }

    CatchAnchorPad? bestPad;
    double bestDist = 96.0;
    for (final pad in level.catchPads) {
      final d = (pad.position - lightPos).distance;
      if (d < bestDist) {
        bestDist = d;
        bestPad = pad;
      }
    }

    if (bestPad != null) {
      lightPos = bestPad.position;
      lightVel = Offset.zero;
      lightAnchored = true;
      _spawnBurst(lightPos, const Color(0xFF22D3EE), 22);
      shakeIntensity = 5.0;
      _showBanner('ANCHORED on ${bestPad.label}! Hold TOW to yank Heavy under!');
      if (!twoPlayerMode) activeChar = ActiveCharacter.heavy;
      HapticFeedback.mediumImpact();
    } else {
      // Mid-air emergency catch clamp wherever Light is (drops fast to ground or locks mid-air)
      lightVel = Offset.zero;
      lightAnchored = true;
      _spawnBurst(lightPos, const Color(0xFF22D3EE), 16);
      shakeIntensity = 4.0;
      _showBanner('Emergency Airborne Anchor LOCKED! Hold TOW!');
      if (!twoPlayerMode) activeChar = ActiveCharacter.heavy;
      HapticFeedback.mediumImpact();
    }
    notifyListeners();
  }

  void launchLightFromDrag(Offset worldStart, Offset worldEnd) {
    if (isLevelComplete || isFailed) return;
    final d = worldStart - worldEnd;
    if (d.distance < 12) return;
    if (lightAnchored) lightAnchored = false;
    final dir = d / d.distance;
    final power = (d.distance * 5.6).clamp(320.0, 680.0);
    lightVel = Offset(dir.dx * power, (dir.dy * power).clamp(-480.0, 120.0));
    lightGrounded = false;
    lightFacing = lightVel.dx >= 0 ? 1.0 : -1.0;
    _spawnBurst(lightPos, lightColor, 14);
    notifyListeners();
  }

  double get activeHeavyRadius => heavyTowing ? heavySlidingRadius : heavyStandingRadius;

  Color get lightColor =>
      CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex].primaryColor;

  void _showBanner(String text) {
    statusBanner = text;
    bannerTimer = 3.2;
  }

  void step(double dt) {
    final clampedDt = dt.clamp(0.0, 0.033);
    animTime += clampedDt;
    if (bannerTimer > 0) bannerTimer = math.max(0.0, bannerTimer - clampedDt);
    if (shakeIntensity > 0) shakeIntensity = math.max(0.0, shakeIntensity - clampedDt * 18.0);
    _updateParticles(clampedDt);

    if (isLevelComplete || isFailed) {
      notifyListeners();
      return;
    }
    elapsedSeconds += clampedDt;

    // 1. Update Security Blast Gates
    for (final gate in level.gates) {
      if (!gate.triggered && (lightPos.dx >= gate.triggerX || heavyPos.dx >= gate.triggerX)) {
        gate.triggered = true;
        _showBanner('ALERT: Security Blast Gate closing!');
        shakeIntensity = 3.5;
      }
      if (gate.triggered && gate.timer < gate.closeDuration) {
        gate.timer = math.min(gate.closeDuration, gate.timer + clampedDt);
        if (gate.isSealed && gate.timer >= gate.closeDuration - clampedDt) {
          shakeIntensity = 7.0;
          _spawnBurst(Offset(gate.x, gate.floorY - 8), const Color(0xFFEF4444), 18);
        }
      }
    }

    // 2. Update Light Player
    if (!lightAnchored) {
      if (lightBlitzTimer > 0) {
        lightBlitzTimer = math.max(0.0, lightBlitzTimer - clampedDt);
        // Active rocket blitz: low gravity, minimal drag so Light rockets cleanly through doors
        lightVel = Offset(
          lightVel.dx * (1.0 - 0.15 * clampedDt),
          lightVel.dy + (gravity * 0.35) * clampedDt,
        );
        if ((animTime * 45).floor() % 2 == 0) {
          _spawnParticle(lightPos, lightColor, 3.0, 0.25);
        }
      } else {
        final targetVx = lightMoveInput * 285.0;
        if (lightMoveInput.abs() > 0.05) lightFacing = lightMoveInput.sign;
        final accel = lightGrounded ? 15.0 : 5.5;
        lightVel = Offset(
          lightVel.dx + (targetVx - lightVel.dx) * math.min(1.0, accel * clampedDt),
          lightVel.dy + gravity * clampedDt,
        );
      }
      lightPos += lightVel * clampedDt;
      lightGrounded = _resolveStaticCollisions(isLight: true, radius: lightRadius);
    } else {
      lightVel = Offset.zero;
      lightBlitzTimer = 0.0;
    }

    // 3. Update Heavy Player & High-Speed Emergency Tow
    if (heavyMoveInput.abs() > 0.05) heavyFacing = heavyMoveInput.sign;
    heavyTowing = lightAnchored && heavyTowHeld;

    if (heavyTowing) {
      final toLight = lightPos - heavyPos;
      final d = toLight.distance;
      if (d > 28) {
        final dir = toLight / d;
        heavyVel = Offset(
          dir.dx * 560.0,
          heavyVel.dy + gravity * clampedDt,
        );
        heavyFacing = dir.dx >= 0 ? 1.0 : -1.0;
        if ((animTime * 45).floor() % 2 == 0) {
          _spawnParticle(heavyPos + Offset(0, heavySlidingRadius), const Color(0xFFFBBF24), 3.2, 0.25);
        }
      } else {
        heavyVel = Offset(0, heavyVel.dy + gravity * clampedDt);
      }
    } else {
      final targetHeavyVx = heavyMoveInput * 145.0;
      heavyVel = Offset(
        heavyVel.dx + (targetHeavyVx - heavyVel.dx) * math.min(1.0, 12.0 * clampedDt),
        heavyVel.dy + gravity * clampedDt,
      );
    }

    heavyPos += heavyVel * clampedDt;
    heavyGrounded = _resolveStaticCollisions(isLight: false, radius: activeHeavyRadius);

    // 4. Check Security Gate Collisions
    for (final gate in level.gates) {
      final shutter = gate.shutterRect;
      if (_circleHitsRect(lightPos, lightRadius, shutter)) {
        _triggerFail('Light collided with the slamming security gate!');
        return;
      }
      if (_circleHitsRect(heavyPos, activeHeavyRadius, shutter)) {
        _triggerFail('Blast Gate sealed on Heavy! Anchor faster & hold TOW to slide under!');
        return;
      }
    }

    // 5. Tether Visual Tension
    final dist = (heavyPos - lightPos).distance;
    currentTension = (dist / 650.0).clamp(0.0, 1.0);

    // 6. Energy Cores
    for (final core in cores) {
      if (!core.collected &&
          ((core.position - lightPos).distance < lightRadius + 18 ||
              (core.position - heavyPos).distance < activeHeavyRadius + 18)) {
        core.collected = true;
        _spawnBurst(core.position, const Color(0xFFFBBF24), 16);
        HapticFeedback.lightImpact();
      }
    }

    // 7. Win Condition
    final lightInGoal = level.goalZone.inflate(22).contains(lightPos);
    final heavyInGoal = level.goalZone.inflate(26).contains(heavyPos);
    if (lightInGoal && heavyInGoal) {
      isLevelComplete = true;
      final collectedCount = cores.where((c) => c.collected).length;
      earnedStars = math.max(1, collectedCount);
      if (collectedCount == 3 && elapsedSeconds <= level.parSeconds) earnedStars = 3;
      _spawnBurst(level.goalZone.center, const Color(0xFF34D399), 34);
      shakeIntensity = 6.0;
      _persistWin();
    }

    // 8. Smooth Camera
    final midX = (lightPos.dx + heavyPos.dx) * 0.5 + 80;
    camCenter = Offset(
      camCenter.dx + (midX - camCenter.dx) * math.min(1.0, 6.0 * clampedDt),
      330.0,
    );
    notifyListeners();
  }

  bool _circleHitsRect(Offset pos, double r, Rect rect) {
    final cx = pos.dx.clamp(rect.left, rect.right);
    final cy = pos.dy.clamp(rect.top, rect.bottom);
    final dx = pos.dx - cx;
    final dy = pos.dy - cy;
    return dx * dx + dy * dy < r * r;
  }

  bool _resolveStaticCollisions({required bool isLight, required double radius}) {
    var pos = isLight ? lightPos : heavyPos;
    var vel = isLight ? lightVel : heavyVel;
    bool grounded = false;

    for (final block in level.blocks) {
      final rect = block.rect;
      final cx = pos.dx.clamp(rect.left, rect.right);
      final cy = pos.dy.clamp(rect.top, rect.bottom);
      final dx = pos.dx - cx;
      final dy = pos.dy - cy;
      final dSq = dx * dx + dy * dy;

      if (dSq < radius * radius) {
        if (block.isHazard) {
          _triggerFail(isLight ? 'Light fell into shock trench!' : 'Heavy fell into shock trench! Tow across!');
          return false;
        }
        final d = math.sqrt(dSq);
        if (d > 0.0001) {
          final nx = dx / d;
          final ny = dy / d;
          pos += Offset(nx * (radius - d), ny * (radius - d));
          final vn = vel.dx * nx + vel.dy * ny;
          if (vn < 0) vel -= Offset(nx * vn, ny * vn);
          if (ny < -0.65) grounded = true;
        } else {
          pos = Offset(pos.dx, rect.top - radius);
          if (vel.dy > 0) vel = Offset(vel.dx, 0);
          grounded = true;
        }
      }
    }

    pos = Offset(
      pos.dx.clamp(radius, level.worldSize.width - radius),
      pos.dy.clamp(radius, level.worldSize.height - radius),
    );
    if (isLight) {
      lightPos = pos;
      lightVel = vel;
    } else {
      heavyPos = pos;
      heavyVel = vel;
    }
    return grounded;
  }

  void _persistWin() {
    final lvl = level.levelNumber;
    final prevStars = StorageService.levelStars[lvl] ?? 0;
    if (earnedStars > prevStars) StorageService.levelStars[lvl] = earnedStars;
    final ms = (elapsedSeconds * 1000).round();
    final prevMs = StorageService.bestTimeMs[lvl];
    if (prevMs == null || ms < prevMs) StorageService.bestTimeMs[lvl] = ms;
    if (lvl >= StorageService.unlockedLevel && lvl < _levels.length) {
      StorageService.unlockedLevel = lvl + 1;
    }
    StorageService.save();
  }

  void _triggerFail(String reason) {
    isFailed = true;
    failReason = reason;
    shakeIntensity = 9.0;
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  void _spawnParticle(Offset pos, Color color, double radius, double life) {
    final rng = math.Random();
    particles.add(Particle(
      pos: pos,
      vel: Offset((rng.nextDouble() - 0.5) * 80 - 60, -rng.nextDouble() * 70),
      color: color,
      radius: radius,
      maxLife: life,
    ));
  }

  void _spawnBurst(Offset pos, Color color, int count) {
    final rng = math.Random();
    for (int i = 0; i < count; i++) {
      final ang = (i / count) * math.pi * 2 + rng.nextDouble() * 0.4;
      final spd = 70 + rng.nextDouble() * 140;
      particles.add(Particle(
        pos: pos,
        vel: Offset(math.cos(ang) * spd, math.sin(ang) * spd),
        color: color,
        radius: 2.5 + rng.nextDouble() * 3.5,
        maxLife: 0.4 + rng.nextDouble() * 0.35,
      ));
    }
  }

  void _updateParticles(double dt) {
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.life -= dt;
      if (p.life <= 0) {
        particles.removeAt(i);
      } else {
        p.pos += p.vel * dt;
      }
    }
  }
}
