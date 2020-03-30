import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Futura',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'Futura',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xff000000),//6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);