import 'package:flutter/material.dart';
import 'game_models.dart';

class AirborneLevels {
  static List<AirborneLevelDefinition> buildAll() => [
        // Level 1: First Lockdown
        AirborneLevelDefinition(
          levelNumber: 1,
          title: 'First Lockdown',
          subtitle: 'Blitz Through & Tow Under',
          hint: 'Tap FIRE SHOT to rocket Light through the closing blast door, hit CATCH ANCHOR, then hold TOW to slide Heavy under!',
          worldSize: const Size(1240, 620),
          lightSpawn: const Offset(210, 445),
          heavySpawn: const Offset(130, 437),
          goalZone: const Rect.fromLTWH(1060, 340, 96, 120),
          parSeconds: 20,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 1200, 160)),
            FloorBlock(Rect.fromLTWH(20, 0, 1200, 140)), // armored upper corridor ceiling
            FloorBlock(Rect.fromLTWH(600, 140, 50, 150)), // blast door housing
          ],
          gates: [
            SecurityBlastGate(
              x: 625,
              topY: 290,
              floorY: 460,
              triggerX: 290,
              closeDuration: 3.0,
              initialOpenRatio: 1.0,
            ),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(860, 444), label: 'CATCH 1'),
          ],
          corePositions: const [
            Offset(460, 395),
            Offset(625, 360),
            Offset(940, 415),
          ],
        ),

        // Level 2: Low Clearance
        AirborneLevelDefinition(
          levelNumber: 2,
          title: 'Low Clearance',
          subtitle: 'Half-Closed Rapid Shutter',
          hint: 'The blast gate starts half-closed and drops fast! Fire a crisp low shot, catch immediately, and slide Heavy under!',
          worldSize: const Size(1300, 620),
          lightSpawn: const Offset(200, 445),
          heavySpawn: const Offset(120, 437),
          goalZone: const Rect.fromLTWH(1120, 340, 96, 120),
          parSeconds: 22,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 1260, 160)),
            FloorBlock(Rect.fromLTWH(20, 0, 1260, 140)),
            FloorBlock(Rect.fromLTWH(640, 140, 54, 150)),
          ],
          gates: [
            SecurityBlastGate(
              x: 667,
              topY: 290,
              floorY: 460,
              triggerX: 280,
              closeDuration: 2.35,
              initialOpenRatio: 0.72,
            ),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(910, 444), label: 'AIRLOCK CATCH'),
          ],
          corePositions: const [
            Offset(500, 405),
            Offset(667, 415),
            Offset(990, 415),
          ],
        ),

        // Level 3: Dual Blast Doors
        AirborneLevelDefinition(
          levelNumber: 3,
          title: 'Dual Blast Doors',
          subtitle: 'Chain Two Airlock Catches',
          hint: 'Clear Gate 1 into the middle chamber, unlock Light, then immediately blitz Gate 2 before the airlock seals!',
          worldSize: const Size(1540, 620),
          lightSpawn: const Offset(180, 445),
          heavySpawn: const Offset(105, 437),
          goalZone: const Rect.fromLTWH(1380, 340, 96, 120),
          parSeconds: 34,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 1500, 160)),
            FloorBlock(Rect.fromLTWH(20, 0, 1500, 140)),
            FloorBlock(Rect.fromLTWH(490, 140, 48, 150)),
            FloorBlock(Rect.fromLTWH(1020, 140, 48, 150)),
          ],
          gates: [
            SecurityBlastGate(
              x: 514,
              topY: 290,
              floorY: 460,
              triggerX: 255,
              closeDuration: 2.75,
              initialOpenRatio: 0.95,
            ),
            SecurityBlastGate(
              x: 1044,
              topY: 290,
              floorY: 460,
              triggerX: 790,
              closeDuration: 2.55,
              initialOpenRatio: 0.9,
            ),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(720, 444), label: 'CHAMBER 1'),
            CatchAnchorPad(Offset(1250, 444), label: 'EXIT CATCH'),
          ],
          corePositions: const [
            Offset(514, 380),
            Offset(860, 415),
            Offset(1044, 385),
          ],
        ),

        // Level 4: Trench & Door
        AirborneLevelDefinition(
          levelNumber: 4,
          title: 'Trench & Door',
          subtitle: 'Jump Hazard & Shoot the Gap',
          hint: 'A shock trench sits right before the shutter! Fire Light in an arc over the trench and tow Heavy cleanly across!',
          worldSize: const Size(1380, 640),
          lightSpawn: const Offset(200, 445),
          heavySpawn: const Offset(120, 437),
          goalZone: const Rect.fromLTWH(1210, 340, 96, 120),
          parSeconds: 26,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 340, 180)),
            FloorBlock(Rect.fromLTWH(360, 515, 190, 125), isHazard: true), // shock trench
            FloorBlock(Rect.fromLTWH(550, 460, 810, 180)),
            FloorBlock(Rect.fromLTWH(20, 0, 1340, 140)),
            FloorBlock(Rect.fromLTWH(740, 140, 50, 150)),
          ],
          gates: [
            SecurityBlastGate(
              x: 765,
              topY: 290,
              floorY: 460,
              triggerX: 300,
              closeDuration: 2.9,
              initialOpenRatio: 0.95,
            ),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(1010, 444), label: 'FAR CATCH'),
          ],
          corePositions: const [
            Offset(455, 365),
            Offset(765, 390),
            Offset(1100, 415),
          ],
        ),

        // Level 5: Laser Shutter
        AirborneLevelDefinition(
          levelNumber: 5,
          title: 'Laser Shutter',
          subtitle: 'Razor-Thin 2.1s Blast Window',
          hint: 'High-speed lockdown! Fire early, snap Airborne Anchor Catch mid-flight, and tow Heavy right under the steel edge!',
          worldSize: const Size(1360, 620),
          lightSpawn: const Offset(190, 445),
          heavySpawn: const Offset(115, 437),
          goalZone: const Rect.fromLTWH(1190, 340, 96, 120),
          parSeconds: 24,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 1320, 160)),
            FloorBlock(Rect.fromLTWH(20, 0, 1320, 140)),
            FloorBlock(Rect.fromLTWH(640, 140, 54, 150)),
            FloorBlock(Rect.fromLTWH(1290, 140, 50, 320), isHazard: true), // far laser bumper
          ],
          gates: [
            SecurityBlastGate(
              x: 667,
              topY: 290,
              floorY: 460,
              triggerX: 270,
              closeDuration: 2.1,
              initialOpenRatio: 0.8,
            ),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(950, 444), label: 'SNIPER CATCH'),
          ],
          corePositions: const [
            Offset(480, 375),
            Offset(667, 410),
            Offset(1050, 415),
          ],
        ),

        // Level 6: Reactor Escape
        AirborneLevelDefinition(
          levelNumber: 6,
          title: 'Reactor Escape',
          subtitle: 'Triple-Gate Lockdown Run',
          hint: 'Three cascading blast doors separate you from extraction! Blitz, catch, and tow in seamless rhythm!',
          worldSize: const Size(1820, 620),
          lightSpawn: const Offset(170, 445),
          heavySpawn: const Offset(95, 437),
          goalZone: const Rect.fromLTWH(1670, 340, 96, 120),
          parSeconds: 45,
          blocks: const [
            FloorBlock(Rect.fromLTWH(20, 460, 1780, 160)),
            FloorBlock(Rect.fromLTWH(20, 0, 1780, 140)),
            FloorBlock(Rect.fromLTWH(450, 140, 44, 150)),
            FloorBlock(Rect.fromLTWH(920, 140, 44, 150)),
            FloorBlock(Rect.fromLTWH(1390, 140, 44, 150)),
          ],
          gates: [
            SecurityBlastGate(x: 472, topY: 290, floorY: 460, triggerX: 230, closeDuration: 2.5, initialOpenRatio: 0.95),
            SecurityBlastGate(x: 942, topY: 290, floorY: 460, triggerX: 700, closeDuration: 2.35, initialOpenRatio: 0.90),
            SecurityBlastGate(x: 1412, topY: 290, floorY: 460, triggerX: 1170, closeDuration: 2.2, initialOpenRatio: 0.85),
          ],
          catchPads: const [
            CatchAnchorPad(Offset(660, 444), label: 'BAY 1'),
            CatchAnchorPad(Offset(1130, 444), label: 'BAY 2'),
            CatchAnchorPad(Offset(1570, 444), label: 'EXTRACTION'),
          ],
          corePositions: const [
            Offset(472, 390),
            Offset(942, 390),
            Offset(1412, 395),
          ],
        ),
      ];
}

