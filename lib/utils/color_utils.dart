import 'package:flutter/material.dart';

Color darkenColorHSL(Color color, {double factor = 0.1}) {
  HSLColor hslColor = HSLColor.fromColor(color);

  hslColor =
      hslColor.withLightness((hslColor.lightness - factor).clamp(0.0, 1.0));

  hslColor = hslColor.withHue((hslColor.hue + 15.0) % 360.0);

  hslColor =
      hslColor.withSaturation((hslColor.saturation - factor).clamp(0.0, 1.0));

  return hslColor.toColor();
}

Color lightenColorHSL(Color color, {double factor = 0.1}) {
  HSLColor hslColor = HSLColor.fromColor(color);

  hslColor =
      hslColor.withLightness((hslColor.lightness + factor).clamp(0.0, 1.0));

  hslColor = hslColor.withHue((hslColor.hue - 10.0) % 360.0);

  hslColor =
      hslColor.withSaturation((hslColor.saturation + factor).clamp(0.0, 1.0));

  return hslColor.toColor();
}
