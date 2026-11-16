import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../engine/airborne_engine.dart';
import '../models/customization.dart';
import '../services/storage_service.dart';

class AirborneCameraTransform {
  final double scale;
  final Offset translation;
  const AirborneCameraTransform(this.scale, this.translation);

  Offset screenToWorld(Offset screen) => (screen - translation) / scale;
}

AirborneCameraTransform computeAirborneCamera(AirborneEngine engine, Size viewport) {
  final spanX = (engine.lightPos.dx - engine.heavyPos.dx).abs() + 480.0;
  const spanY = 460.0;
  final fitX = viewport.width / math.max(spanX, 660.0);
  final fitY = viewport.height / spanY;
  final scale = math.min(fitX, fitY).clamp(0.42, 1.35);

  final worldW = engine.level.worldSize.width;
  final worldH = engine.level.worldSize.height;
  double cx = engine.camCenter.dx;
  double cy = engine.camCenter.dy;

  final halfW = (viewport.width * 0.5) / scale;
  final halfH = (viewport.height * 0.5) / scale;
  cx = worldW > halfW * 2 ? cx.clamp(halfW, worldW - halfW) : worldW * 0.5;
  cy = worldH > halfH * 2 ? cy.clamp(halfH - 20, worldH - halfH + 20) : worldH * 0.5;

  return AirborneCameraTransform(
    scale,
    Offset(viewport.width * 0.5 - cx * scale, viewport.height * 0.5 - cy * scale),
  );
}

class AirbornePainter extends CustomPainter {
  final AirborneEngine engine;
  AirbornePainter(this.engine) : super(repaint: engine);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = CustomizationCatalog.backgrounds[StorageService.backgroundIndex];
    final lightSkin = CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex];
    final heavySkin = CustomizationCatalog.heavyProfiles[StorageService.heavyProfileIndex];
    final tetherSkin = CustomizationCatalog.tetherStyles[StorageService.tetherStyleIndex];
    final cam = computeAirborneCamera(engine, size);

    // High-speed corridor streaks
    final streakPaint = Paint()..color = bg.accentColor.withValues(alpha: 0.22)..strokeWidth = 1.8;
    for (int i = 0; i < 12; i++) {
      final x = size.width - ((engine.animTime * (120 + i * 14) + i * 95) % (size.width + 80));
      final y = (i * 59.0) % size.height;
      canvas.drawLine(Offset(x, y), Offset(x + 28, y), streakPaint);
    }

    canvas.save();
    if (engine.shakeIntensity > 0.1) {
      canvas.translate(
        math.sin(engine.animTime * 65) * engine.shakeIntensity,
        math.cos(engine.animTime * 57) * engine.shakeIntensity,
      );
    }
    canvas.translate(cam.translation.dx, cam.translation.dy);
    canvas.scale(cam.scale);

    // 1. Floor & Ceiling Blocks
    for (final b in engine.level.blocks) {
      if (b.isHazard) {
        canvas.drawRRect(RRect.fromRectAndRadius(b.rect, const Radius.circular(6)), Paint()..color = const Color(0xFF450A0A));
        canvas.drawRRect(RRect.fromRectAndRadius(b.rect, const Radius.circular(6)), Paint()..color = const Color(0xFFEF4444)..style = PaintingStyle.stroke..strokeWidth = 2.5);
      } else {
        final rr = RRect.fromRectAndRadius(b.rect, const Radius.circular(6));
        canvas.drawRRect(rr, Paint()..color = bg.platformBodyColor);
        canvas.drawLine(Offset(b.rect.left + 4, b.rect.top + 2), Offset(b.rect.right - 4, b.rect.top + 2), Paint()..color = bg.accentColor.withValues(alpha: 0.65)..strokeWidth = 2.5);
      }
    }

    // 2. Security Blast Gates + Laser Tripwires + Countdown Arcs
    for (final gate in engine.level.gates) {
      // Tripwire vertical beam
      if (!gate.triggered) {
        canvas.drawLine(
          Offset(gate.triggerX, gate.topY - 120),
          Offset(gate.triggerX, gate.floorY),
          Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.45)..strokeWidth = 2,
        );
      }

      // Armored door shutter
      final shutter = gate.shutterRect;
      canvas.drawRRect(RRect.fromRectAndRadius(shutter, const Radius.circular(4)), Paint()..color = const Color(0xFF334155));
      canvas.drawRRect(RRect.fromRectAndRadius(shutter, const Radius.circular(4)), Paint()..color = const Color(0xFFEF4444)..style = PaintingStyle.stroke..strokeWidth = 2.8);
      // Warning glowing bottom edge laser
      canvas.drawLine(
        Offset(shutter.left, shutter.bottom),
        Offset(shutter.right, shutter.bottom),
        Paint()..color = const Color(0xFFF43F5E)..strokeWidth = 4,
      );

      // Countdown ring above gate
      if (gate.triggered && !gate.isSealed) {
        final rem = 1.0 - (gate.timer / gate.closeDuration).clamp(0.0, 1.0);
        final ringCenter = Offset(gate.x, gate.topY - 38);
        canvas.drawCircle(ringCenter, 18, Paint()..color = const Color(0xFF0F172A));
        canvas.drawArc(
          Rect.fromCircle(center: ringCenter, radius: 18),
          -math.pi / 2,
          math.pi * 2 * rem,
          false,
          Paint()..color = rem < 0.35 ? const Color(0xFFEF4444) : const Color(0xFFF59E0B)..style = PaintingStyle.stroke..strokeWidth = 4,
        );
      }
    }

    // 3. Catch Anchor Pads
    for (final pad in engine.level.catchPads) {
      canvas.drawCircle(pad.position, 24, Paint()..color = lightSkin.glowColor.withValues(alpha: 0.18));
      canvas.drawCircle(pad.position, 13, Paint()..color = lightSkin.glowColor..style = PaintingStyle.stroke..strokeWidth = 2.8);
      canvas.drawCircle(pad.position, 5, Paint()..color = Colors.white);
    }

    // 4. Exit Goal
    final gc = engine.level.goalZone.center;
    final gr = engine.level.goalZone.width * 0.42 * (1 + 0.08 * math.sin(engine.animTime * 5));
    canvas.drawCircle(gc, gr + 8, Paint()..color = const Color(0xFF34D399).withValues(alpha: 0.25));
    canvas.drawCircle(gc, gr, Paint()..color = const Color(0xFF34D399)..style = PaintingStyle.stroke..strokeWidth = 4);

    // 5. Energy Cores
    for (final core in engine.cores) {
      if (!core.collected) {
        final bob = math.sin(engine.animTime * 4 + core.position.dx * 0.03) * 4;
        final pos = core.position + Offset(0, bob);
        canvas.drawCircle(pos, 15, Paint()..color = const Color(0xFFFBBF24).withValues(alpha: 0.25));
        canvas.drawCircle(pos, 8, Paint()..color = const Color(0xFFFBBF24));
      }
    }

    // 6. Tow Tether
    final lineColor = engine.heavyTowing ? const Color(0xFF22D3EE) : tetherSkin.primaryColor;
    canvas.drawLine(engine.lightPos, engine.heavyPos, Paint()..color = lineColor.withValues(alpha: 0.35)..strokeWidth = engine.heavyTowing ? 9 : 6..strokeCap = StrokeCap.round);
    canvas.drawLine(engine.lightPos, engine.heavyPos, Paint()..color = lineColor..strokeWidth = 3.2..strokeCap = StrokeCap.round);

    // 7. Characters
    _drawHeavy(canvas, engine.heavyPos, heavySkin, engine.heavyFacing, engine.heavyTowing, engine.activeChar == ActiveCharacter.heavy && !engine.twoPlayerMode);
    _drawLight(canvas, engine.lightPos, lightSkin, engine.lightFacing, engine.lightAnchored, engine.activeChar == ActiveCharacter.light && !engine.twoPlayerMode);

    for (final pt in engine.particles) {
      final a = (pt.life / pt.maxLife).clamp(0.0, 1.0);
      canvas.drawCircle(pt.pos, pt.radius * a, Paint()..color = pt.color.withValues(alpha: a));
    }

    canvas.restore();
  }

  void _drawLight(Canvas canvas, Offset pos, LightProfile skin, double facing, bool anchored, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (selected) {
      canvas.drawCircle(Offset.zero, 23, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    if (anchored) {
      final p = Paint()..color = skin.glowColor..strokeWidth = 3;
      canvas.drawLine(const Offset(-6, 8), const Offset(-16, 18), p);
      canvas.drawLine(const Offset(6, 8), const Offset(16, 18), p);
    }
    canvas.drawCircle(Offset.zero, AirborneEngine.lightRadius, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset.zero, AirborneEngine.lightRadius, Paint()..color = skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(facing * 4, -2), width: 13, height: 7), const Radius.circular(3)), Paint()..color = skin.glowColor);
    canvas.restore();
  }

  void _drawHeavy(Canvas canvas, Offset pos, HeavyProfile skin, double facing, bool sliding, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (selected) {
      canvas.drawCircle(Offset.zero, 30, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    if (sliding) {
      // Low-profile horizontal skid silhouette!
      final skid = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 44, height: 26), const Radius.circular(13));
      canvas.drawRRect(skid, Paint()..color = const Color(0xFF1E293B));
      canvas.drawRRect(skid, Paint()..color = skin.glowColor..style = PaintingStyle.stroke..strokeWidth = 3.8);
      canvas.drawCircle(Offset(facing * 8, -2), 3, Paint()..color = Colors.white);
    } else {
      canvas.drawCircle(Offset.zero, AirborneEngine.heavyStandingRadius, Paint()..color = const Color(0xFF1E293B));
      canvas.drawCircle(Offset.zero, AirborneEngine.heavyStandingRadius, Paint()..color = skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 4);
      canvas.drawCircle(const Offset(-17, -4), 7, Paint()..color = skin.primaryColor);
      canvas.drawCircle(const Offset(17, -4), 7, Paint()..color = skin.primaryColor);
      canvas.drawCircle(Offset(facing * 3 - 4, -5), 2.5, Paint()..color = skin.glowColor);
      canvas.drawCircle(Offset(facing * 3 + 4, -5), 2.5, Paint()..color = skin.glowColor);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AirbornePainter oldDelegate) => true;
}

