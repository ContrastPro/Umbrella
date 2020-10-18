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
const cl_background = const Color(0xffefeeee);
const cl_darkShadow = const Color(0xffd1cdc7);
const cl_lightShadow = const Color(0xffffffff);
const tl_primary = const Color(0xff323232);


// Dark Mode
const cd_background = const Color(0xff292d32);
const cd_darkShadow = const Color(0xff23262b);
const cd_lightShadow = const Color(0xff2f343a);
const td_primary = const Color(0xffffffff);

///Box Shadows for all boxes

BoxShadow setBoxShadowDark(bool darkMode) {
  return BoxShadow(
      color: darkMode != true ? cl_darkShadow.withOpacity(0.65) : cd_darkShadow,
      offset: Offset(6.0, 6.0),
      blurRadius: 16.0,
      spreadRadius: 1.0);
}

BoxShadow setBoxShadowLight(bool darkMode) {
  return BoxShadow(
      color: darkMode != true ? cl_lightShadow.withOpacity(0.8) : cd_lightShadow,
      offset: Offset(-6.0, -6.0),
      blurRadius: 16.0,
      spreadRadius: 1.0);
}
