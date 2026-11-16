import 'package:flutter/material.dart';

class LightProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const LightProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class HeavyProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const HeavyProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class BackgroundThemeOption {
  final String id;
  final String name;
  final String subtitle;
  final String assetPath;
  final Color skyTint;
  final Color accentColor;
  final Color platformTopColor;
  final Color platformBodyColor;

  const BackgroundThemeOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.assetPath,
    required this.skyTint,
    required this.accentColor,
    required this.platformTopColor,
    required this.platformBodyColor,
  });
}

enum TetherPattern { plasma, steel, magChain, runic }

class TetherStyleOption {
  final String id;
  final String name;
  final String subtitle;
  final Color primaryColor;
  final Color pulseColor;
  final TetherPattern pattern;

  const TetherStyleOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.primaryColor,
    required this.pulseColor,
    required this.pattern,
  });
}

class PilotBadgeOption {
  final String id;
  final String name;
  final String callsign;
  final IconData icon;
  final Color badgeColor;

  const PilotBadgeOption({
    required this.id,
    required this.name,
    required this.callsign,
    required this.icon,
    required this.badgeColor,
  });
}

class CustomizationCatalog {
  static const List<LightProfile> lightProfiles = [
    LightProfile(
      id: 'aero_wisp',
      name: 'Aero-Wisp',
      title: 'Blitz Rocket Dart',
      perk: 'Micro-Aperture Thruster',
      assetPath: 'assets/images/profiles/light_aero_wisp.png',
      primaryColor: Color(0xFF38BDF8),
      glowColor: Color(0xFF22D3EE),
    ),
    LightProfile(
      id: 'volt_sprite',
      name: 'Volt-Sprite',
      title: 'Laser-Gap Sprinter',
      perk: 'Instant Mag-Catch',
      assetPath: 'assets/images/profiles/light_volt_sprite.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFF6EE7B7),
    ),
    LightProfile(
      id: 'solar_falcon',
      name: 'Solar-Falcon',
      title: 'Supersonic Striker',
      perk: 'Afterburner Blitz',
      assetPath: 'assets/images/profiles/light_solar_falcon.png',
      primaryColor: Color(0xFFFBBF24),
      glowColor: Color(0xFFFB7185),
    ),
    LightProfile(
      id: 'nebula_lynx',
      name: 'Nebula-Lynx',
      title: 'Breach Interceptor',
      perk: 'Phase-Lock Anchor',
      assetPath: 'assets/images/profiles/light_nebula_lynx.png',
      primaryColor: Color(0xFFE879F9),
      glowColor: Color(0xFFC084FC),
    ),
  ];

  static const List<HeavyProfile> heavyProfiles = [
    HeavyProfile(
      id: 'titan_core',
      name: 'Titan-Core',
      title: 'Armored Tow Slider',
      perk: 'Low-Profile Skid Hull',
      assetPath: 'assets/images/profiles/heavy_titan_core.png',
      primaryColor: Color(0xFFFB923C),
      glowColor: Color(0xFFFBBF24),
    ),
    HeavyProfile(
      id: 'bastion_mk4',
      name: 'Bastion-MK4',
      title: 'Cobalt Breach Tank',
      perk: 'High-Speed Tow Clutch',
      assetPath: 'assets/images/profiles/heavy_bastion_mk4.png',
      primaryColor: Color(0xFF60A5FA),
      glowColor: Color(0xFF93C5FD),
    ),
    HeavyProfile(
      id: 'magma_atlas',
      name: 'Magma-Atlas',
      title: 'Friction Spark Runner',
      perk: 'Titanium Slide Skids',
      assetPath: 'assets/images/profiles/heavy_magma_atlas.png',
      primaryColor: Color(0xFFF43F5E),
      glowColor: Color(0xFFF97316),
    ),
    HeavyProfile(
      id: 'jade_bulwark',
      name: 'Jade-Bulwark',
      title: 'Vault Buster Unit',
      perk: 'Stabilized Tow Core',
      assetPath: 'assets/images/profiles/heavy_jade_bulwark.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFFFBBF24),
    ),
  ];

  static const List<BackgroundThemeOption> backgrounds = [
    BackgroundThemeOption(
      id: 'reactor_lockdown',
      name: 'Reactor Lockdown',
      subtitle: 'Amber Titanium Corridor',
      assetPath: 'assets/images/backgrounds/bg_1.png',
      skyTint: Color(0xFF1F2937),
      accentColor: Color(0xFFF59E0B),
      platformTopColor: Color(0xFFD97706),
      platformBodyColor: Color(0xFF111827),
    ),
    BackgroundThemeOption(
      id: 'orbital_airlock',
      name: 'Orbital Airlock',
      subtitle: 'Deep-Space Station Bay',
      assetPath: 'assets/images/backgrounds/bg_2.png',
      skyTint: Color(0xFF0F172A),
      accentColor: Color(0xFF38BDF8),
      platformTopColor: Color(0xFF0284C7),
      platformBodyColor: Color(0xFF082F49),
    ),
    BackgroundThemeOption(
      id: 'vault_bunker',
      name: 'Vault Bunker',
      subtitle: 'Crimson Blast Chamber',
      assetPath: 'assets/images/backgrounds/bg_3.png',
      skyTint: Color(0xFF27272A),
      accentColor: Color(0xFFEF4444),
      platformTopColor: Color(0xFFDC2626),
      platformBodyColor: Color(0xFF18181B),
    ),
    BackgroundThemeOption(
      id: 'cyber_tunnel',
      name: 'Cyber Tunnel',
      subtitle: 'Neon Express Airlock',
      assetPath: 'assets/images/backgrounds/bg_4.png',
      skyTint: Color(0xFF3B0764),
      accentColor: Color(0xFF22D3EE),
      platformTopColor: Color(0xFF06B6D4),
      platformBodyColor: Color(0xFF190624),
    ),
  ];

  static const List<TetherStyleOption> tetherStyles = [
    TetherStyleOption(
      id: 'blitz_tow_beam',
      name: 'Blitz Tow Beam',
      subtitle: 'Hyper-Snap Catch Line',
      primaryColor: Color(0xFF22D3EE),
      pulseColor: Color(0xFFFFFFFF),
      pattern: TetherPattern.plasma,
    ),
    TetherStyleOption(
      id: 'titanium_tow',
      name: 'Titanium Towline',
      subtitle: 'Armored Winch Cable',
      primaryColor: Color(0xFFF59E0B),
      pulseColor: Color(0xFFFEF08A),
      pattern: TetherPattern.steel,
    ),
    TetherStyleOption(
      id: 'mag_clutch',
      name: 'Mag-Clutch Link',
      subtitle: 'Pulse Tow Nodes',
      primaryColor: Color(0xFFE879F9),
      pulseColor: Color(0xFF38BDF8),
      pattern: TetherPattern.magChain,
    ),
    TetherStyleOption(
      id: 'runic_snare',
      name: 'Runic Tow Cord',
      subtitle: 'Golden Catch Thread',
      primaryColor: Color(0xFF34D399),
      pulseColor: Color(0xFFFEF08A),
      pattern: TetherPattern.runic,
    ),
  ];

  static const List<PilotBadgeOption> pilotBadges = [
    PilotBadgeOption(
      id: 'gate_breaker',
      name: 'Gate Breaker',
      callsign: 'BLITZ-1',
      icon: Icons.door_sliding_rounded,
      badgeColor: Color(0xFFEF4444),
    ),
    PilotBadgeOption(
      id: 'catch_ace',
      name: 'Airborne Catch',
      callsign: 'TOW-X',
      icon: Icons.bolt_rounded,
      badgeColor: Color(0xFF22D3EE),
    ),
    PilotBadgeOption(
      id: 'airlock_shield',
      name: 'Airlock Shield',
      callsign: 'SEAL-9',
      icon: Icons.shield_rounded,
      badgeColor: Color(0xFFF59E0B),
    ),
    PilotBadgeOption(
      id: 'anchor_clutch',
      name: 'Clutch Anchor',
      callsign: 'LOCK-7',
      icon: Icons.anchor_rounded,
      badgeColor: Color(0xFF34D399),
    ),
  ];
}

