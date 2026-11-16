import 'package:flutter/material.dart';

class FloorBlock {
  final Rect rect;
  final bool isHazard;
  const FloorBlock(this.rect, {this.isHazard = false});
}

class CatchAnchorPad {
  final Offset position;
  final String label;
  const CatchAnchorPad(this.position, {this.label = 'CATCH PAD'});
}

class SecurityBlastGate {
  final double x;
  final double topY;
  final double floorY;
  final double width;
  final double triggerX;
  final double closeDuration;
  final double initialOpenRatio;

  bool triggered;
  double timer;

  SecurityBlastGate({
    required this.x,
    required this.topY,
    required this.floorY,
    this.width = 34.0,
    required this.triggerX,
    this.closeDuration = 2.6,
    this.initialOpenRatio = 1.0,
    this.triggered = false,
    this.timer = 0.0,
  });

  double get openRatio {
    if (!triggered) return initialOpenRatio;
    final progress = (timer / closeDuration).clamp(0.0, 1.0);
    return (initialOpenRatio * (1.0 - progress)).clamp(0.0, 1.0);
  }

  double get bottomEdgeY {
    final fullHeight = floorY - topY;
    final currentGap = fullHeight * openRatio;
    return floorY - currentGap;
  }

  Rect get shutterRect => Rect.fromLTWH(x - width * 0.5, topY, width, bottomEdgeY - topY);
  bool get isSealed => openRatio <= 0.08;
}

class EnergyCore {
  final Offset position;
  bool collected;
  EnergyCore(this.position, {this.collected = false});
}

class Particle {
  Offset pos;
  Offset vel;
  Color color;
  double radius;
  double life;
  double maxLife;

  Particle({
    required this.pos,
    required this.vel,
    required this.color,
    required this.radius,
    required this.maxLife,
  }) : life = maxLife;
}

class AirborneLevelDefinition {
  final int levelNumber;
  final String title;
  final String subtitle;
  final String hint;
  final Size worldSize;
  final Offset lightSpawn;
  final Offset heavySpawn;
  final Rect goalZone;
  final double parSeconds;
  final List<FloorBlock> blocks;
  final List<SecurityBlastGate> gates;
  final List<CatchAnchorPad> catchPads;
  final List<Offset> corePositions;

  const AirborneLevelDefinition({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.worldSize,
    required this.lightSpawn,
    required this.heavySpawn,
    required this.goalZone,
    required this.parSeconds,
    required this.blocks,
    required this.gates,
    required this.catchPads,
    required this.corePositions,
  });
}

