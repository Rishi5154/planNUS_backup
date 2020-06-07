import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class for abstracting all customised widgets
class HelperWidgets {

  static Flushbar flushbar(String text, IconData icon) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      //message: 'FAILED TO SIGN IN!',
      messageText: Text(text,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          )),
      icon: Icon(
          icon,
          size: 28,
          color: Colors.lightBlueAccent
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.lightBlueAccent,
    );
  }



}