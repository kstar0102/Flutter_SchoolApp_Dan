import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TripStatus {
  all,
  pending,
  accepted,
  rejected,
  started,
  canceled,
  finished,
  fake,
}

Color getStatusColor(TripStatus status) {
  const List<Color> kStatusColors = [
    Colors.black,
    Color(0xFFFBB03B),
    Color(0xFFA67C52),
    Color(0xFFED1C24),
    Color(0xFF29ABE2),
    Color(0xFFFF00FF),
    Color(0xFF39B54A),
    Color(0xFF949494),
  ];
  return kStatusColors[status.index];
}
