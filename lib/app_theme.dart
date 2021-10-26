import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.blue,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFAFAFA),
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    headline5: TextStyle(
      wordSpacing: 4,
      color: Color(0xFF3E3838),
    ),
    bodyText2: TextStyle(
      color: Color(0xFF828282),
    ),
  ),
);
