import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airborne_anchor_catch/engine/airborne_engine.dart';
import 'package:airborne_anchor_catch/main.dart';
import 'package:airborne_anchor_catch/models/customization.dart';
import 'package:airborne_anchor_catch/models/levels.dart';

void main() {
  test('Customization catalog provides 4 options per selection', () {
    expect(CustomizationCatalog.lightProfiles.length, 4);
    expect(CustomizationCatalog.heavyProfiles.length, 4);
    expect(CustomizationCatalog.backgrounds.length, 4);
    expect(CustomizationCatalog.tetherStyles.length, 4);
    expect(CustomizationCatalog.pilotBadges.length, 4);
  });

  test('Airborne Anchor Catch fires Light through closing gate, catches anchor, and tows Heavy under', () {
    final levels = AirborneLevels.buildAll();
    expect(levels.length, 6);
    final engine = AirborneEngine(initialLevelIndex: 0);

    // Fire Light through closing security gate
    engine.fireLightBlitz();
    for (int i = 0; i < 65; i++) {
      engine.step(0.016);
    }
    expect(engine.lightPos.dx, greaterThan(engine.level.gates.first.x));

    // Catch anchor on far side and tow Heavy safely underneath door
    engine.catchAnchor();
    expect(engine.lightAnchored, isTrue);

    engine.heavyTowHeld = true;
    for (int i = 0; i < 90; i++) {
      engine.step(0.016);
    }
    expect(engine.heavyPos.dx, greaterThan(engine.level.gates.first.x));
    expect(engine.isFailed, isFalse);
  });

  testWidgets('Airborne Anchor Catch HomeScreen renders title, customization, and levels', (tester) async {
    await tester.pumpWidget(const AirborneAnchorCatchApp());
    await tester.pumpAndSettle();

    expect(find.text('AIRBORNE ANCHOR CATCH'), findsOneWidget);
    expect(find.text('First Lockdown'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(4));
  });
}
