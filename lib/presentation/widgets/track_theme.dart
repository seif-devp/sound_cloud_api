import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sound_cloud_api/data/models/track_model.dart';

class TrackTheme {
  const TrackTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  final Color primary;
  final Color secondary;
  final Color accent;

  static TrackTheme fromTrack(Track track) {
    final hash = (track.title + track.artist.name).hashCode;
    final hue = (hash.abs() % 360).toDouble();
    final altHue = (hue + 55 + (hash.abs() % 80)) % 360;

    final primary = HSLColor.fromAHSL(1, hue, 0.72, 0.38).toColor();
    final secondary = HSLColor.fromAHSL(1, altHue, 0.50, 0.24).toColor();
    final accent = HSLColor.fromAHSL(1, hue, 0.92, 0.70).toColor();

    return TrackTheme(primary: primary, secondary: secondary, accent: accent);
  }

  /// Extract colors from the album cover image using PaletteGenerator.
  static Future<TrackTheme> fromImageUrl(String imageUrl) async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        size: const Size(200, 200),
      );

      // Use dominant color as primary
      final primary = paletteGenerator.dominantColor?.color ?? fallback.primary;

      // Use muted dark color as secondary, or fall back to vibrant
      final secondary =
          paletteGenerator.mutedColor?.color ??
          paletteGenerator.vibrantColor?.color ??
          fallback.secondary;

      // Use light vibrant as accent, or fall back to light muted
      final accent =
          paletteGenerator.lightVibrantColor?.color ??
          paletteGenerator.lightMutedColor?.color ??
          fallback.accent;

      return TrackTheme(primary: primary, secondary: secondary, accent: accent);
    } catch (e) {
      return fallback;
    }
  }

  static const TrackTheme fallback = TrackTheme(
    primary: Color(0xFF6C5CE7),
    secondary: Color(0xFF00E5FF),
    accent: Color(0xFFFFD700),
  );

  LinearGradient get radialGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary.withOpacity(0.45), secondary.withOpacity(0.18)],
  );
}
