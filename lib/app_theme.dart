import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.blue,
    backgroundColor: Color(0xFFFAFAFA),
    elevation: 1,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFAFAFA),
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    headline5: TextStyle(
      wordSpacing: 4,
      color: Colors.grey.shade800,
    ),
    bodyText2: TextStyle(
      color: Colors.grey.shade600,
    ),
  ),
);
