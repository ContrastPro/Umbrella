import 'package:flutter/material.dart';

///App Themes

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  accentColor: Colors.blueGrey,
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

///Colors

// Light Mode
const cl_background = const Color(0xffe0e5ec);
const cl_darkShadow = const Color(0xffbec3c9);
const cl_lightShadow = const Color(0xfff5f5f5);
const tl_primary = const Color(0xff323232);

// Dark Mode
const cd_background = const Color(0xff292d32);
const cd_darkShadow = const Color(0xff23262b);
const cd_lightShadow = const Color(0xff2f343a);
const td_primary = const Color(0xffffffff);

///Box Shadows for all boxes

BoxShadow setBoxShadowDark(bool darkMode) {
  return BoxShadow(
      color: darkMode != true ? cl_darkShadow : cd_darkShadow,
      offset: Offset(4.0, 4.0),
      blurRadius: 15.0,
      spreadRadius: 1.0);
}

BoxShadow setBoxShadowLight(bool darkMode) {
  return BoxShadow(
      color: darkMode != true ? cl_lightShadow : cd_lightShadow,
      offset: Offset(-4.0, -4.0),
      blurRadius: 15.0,
      spreadRadius: 1.0);
}
