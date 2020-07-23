import 'package:flutter/material.dart';

class DiamondNotchedShape extends NotchedShape {
  @override
  Path getOuterPath(Rect host, Rect guest) {
    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(guest.left, host.top)
      ..lineTo(guest.center.dx, guest.bottom)
      ..lineTo(guest.right, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
