import 'package:flutter/material.dart';

SizedBox verticalSpace(double height) => SizedBox(height: height);

SizedBox horizontalSpace(double width) => SizedBox(width: width);

double responsiveFontSize(BuildContext context, double baseSize) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double scaleFactor = (screenWidth + screenHeight) / 1400;
  return baseSize * scaleFactor;
}

double responsiveSpacing(BuildContext context, double baseSpacing) {
  double screenWidth = MediaQuery.of(context).size.width;
  return baseSpacing * (screenWidth / 375);
}

double responsiveSize(
  BuildContext context,
  double baseSize, {
  double min = 0,
  double max = double.infinity,
}) {
  return responsiveSpacing(context, baseSize).clamp(min, max).toDouble();
}
