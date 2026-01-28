import 'package:flutter/material.dart';

abstract class AppInputDecoration {
  static InputDecoration roundBorder = InputDecoration(
    filled: true,
    fillColor: Color(0xffFEFEFE),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Color(0xFFCBCBCB),
        width: 1,
      ),
    ),
    // Border khi focus
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Color(0xFF5B4CCC),
        width: 1.5,
      ),
    ),
    // Border mac dinh
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Color(0xFFCBCBCB), width: 1),
    ),
  );
}
