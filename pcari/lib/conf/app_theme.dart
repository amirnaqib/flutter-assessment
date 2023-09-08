import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ApplicationTheme {
  ApplicationTheme._();

  static const Color primaryColor = Color.fromRGBO(6, 182, 138, 0.74);
  static const Color secondaryColor = Color.fromRGBO(252, 252, 252, 1);

  static const Color successColor = Colors.green;
  static const Color failedColor = Colors.red;

  static const Color yellow = Color.fromARGB(255, 233, 210, 7);

  static const TextStyle title = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle labelling = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );

  // static const TextStyle cardTitle = TextStyle(
  //   fontSize: 12,
  //   color: Colors.black,
  // );

  // static const TextStyle labelWithBold = TextStyle(
  //   fontSize: 17,
  //   color: Colors.black,
  //   fontWeight: FontWeight.bold,
  // );

  // static const TextStyle systemLabelling = TextStyle(
  //   color: CupertinoColors.systemGrey2,
  //   fontSize: 12,
  // );

  // static const TextStyle productHdrLabelling = TextStyle(
  //   color: Color.fromARGB(255, 0, 43, 161),
  //   fontSize: 12,
  // );

  // static const TextStyle productDescLabelling = TextStyle(
  //   color: CupertinoColors.black,
  //   fontSize: 12,
  // );

  // static const TextStyle whiteLabel = TextStyle(
  //   fontSize: 17,
  //   fontWeight: FontWeight.w600,
  //   color: Colors.white,
  // );
}
