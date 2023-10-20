import 'package:flutter/material.dart';

class MapPin {
  String displayName;
  String kind;
  String pinImagePath;
  Color textColor;

  MapPin(this.displayName, this.kind, this.pinImagePath, this.textColor);
}

final mapPins = [
  MapPin("デフォルト", "default", "images/pins/pin_default.svg",
      const Color(0xFFEF5350)),
  MapPin("ご飯もの", "rice", "images/pins/pin_kome.svg", const Color(0xFF4CAF50)),
  MapPin("ラーメン", "ramen", "images/pins/pin_ramen.svg", const Color(0xFF7E57C2)),
  MapPin(
      "喫茶店", "coffee", "images/pins/pin_cafe.svg", const Color(0xFF29B6F6)),
  MapPin("ハンバーガー", "hamburger", "images/pins/pin_ham.svg",
      const Color(0xFFFF7043)),
];

MapPin? findPinByKind(String? kind) {
  if (kind == null) return null;

  for (var v in mapPins) {
    if (v.kind == kind) {
      return v;
    }
  }

  return null;
}
