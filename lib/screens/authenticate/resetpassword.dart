import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/constants.dart';
import 'package:shimmer/shimmer.dart';

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
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple[300], Colors.amber[700], Colors.deepPurpleAccent[100]],
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
              SizedBox(height: 50),
              RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                child: Shimmer.fromColors(
                  highlightColor: Colors.black,
                  baseColor: Colors.white,
                  child: Text(
                    'Reset password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  if(formKey.currentState.validate()) {
                    // checking whether content in form is valid
                    dynamic result = await auth.resetPassword(email);
                    if (result == false) {
                      setState((){
                        error = 'Invalid email!';
                      });
                    } else {
                      setState(() {
                        error = 'Success! Details to reset password '
                            'have been sent to $email';
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12),
              Center(
                child: Text(
                  error,
                  style: GoogleFonts.lato(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
