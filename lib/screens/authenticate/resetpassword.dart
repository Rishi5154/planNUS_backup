import 'package:flutter/material.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/constants.dart';
import 'package:plannusandroidversion/shared/helperwidgets.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>(); // 'id' of form
  // text field state
  String email = '';
  String password = '';
  String handle = '';
  String error = '';

  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple[300], Colors.deepPurple, Colors.deepPurpleAccent[100]],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: formKey,
          child : Column (
            children: <Widget>[
              SizedBox(height: 95,),
              Image.asset('assets/planNUS.png', height: 250, width: 300),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: TextFormField(
                  decoration: textInputDecorationProfile.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                width: 275,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      dynamic result = await auth.resetPassword(email);
                      if (result == false) {
                        HelperWidgets.flushbar('Invalid email!', Icons.account_box)..show(context);
                      } else {
                        HelperWidgets.flushbar('Success! Details to reset password '
                            'have been sent to $email', Icons.email)..show(context);
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.orangeAccent,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.deepPurple[500],
                      letterSpacing: 1.0,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
