import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class for abstracting all customised widgets
class HelperWidgets {

  static final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  static final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 3),
      ),
    ],
  );

  static Flushbar flushbar(String text, IconData icon) {
    return Flushbar(
//      key: Key('flushbar'),
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
          color: Colors.lightBlueAccent,
        key: Key('failed login'),
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.lightBlueAccent,
    );
  }

  static Flushbar TopFlushbar(String text, IconData icon) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
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
  static Widget buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Sign in with',
          style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  static Widget buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildSocialBtn(
                () => print('Login with Google'),
            AssetImage(
              'assets/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

}