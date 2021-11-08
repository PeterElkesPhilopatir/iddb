import 'package:flutter/material.dart';

ButtonStyle getRounded(){
  return ButtonStyle(
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.red),
      shape:
      MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red))));
}

ButtonStyle getBordered(){
  return ButtonStyle(
      shape: MaterialStateProperty.all<
          RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red))));
}