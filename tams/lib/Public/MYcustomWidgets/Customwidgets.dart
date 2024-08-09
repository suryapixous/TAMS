import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Define the start point
    var startPoint =
        Offset(0, size.height * 0.9); // Adjust this height as needed

    // Define the control point
    var controlPoint = Offset(
        size.width * 0.8, size.height * 0.8); // Control point in the middle

    // Define the end point
    var endPoint = Offset(size.width,
        size.height * 0.5); // End point at the same height as the start

    // Start drawing path from the top left corner
    path.lineTo(startPoint.dx, startPoint.dy);

    // Draw the quadratic Bezier curve
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Draw a line to the top right corner
    path.lineTo(size.width, 0);

    // Close the path
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
