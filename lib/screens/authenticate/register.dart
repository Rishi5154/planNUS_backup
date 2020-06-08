import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/shared/constants.dart';
import 'package:plannusandroidversion/shared/helperwidgets.dart';
import 'package:plannusandroidversion/shared/loading.dart';

class Register extends StatefulWidget {
  // setting the property available for use
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>(); // 'id' of form
  bool loading = false;
  // text field state
  String email = '';
  String password = '';
  String handle = '';
  String error = '';

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black54,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person, color: Colors.white),
                  label: Text(
                    'Sign in',
                    style: GoogleFonts.biryani(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurpleAccent[100],
                      Colors.deepPurpleAccent[700]
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                child: Form(
                  key: formKey, // keep track of form and its state
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/planNUS.png',
                          height: 250, width: 300),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: TextFormField(
                          decoration: textInputDecorationProfile.copyWith(
                              hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: TextFormField(
                          decoration: textInputDecorationPassword.copyWith(
                              hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'Enter a longer password!'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: TextFormField(
                          decoration: textInputDecorationEmail.copyWith(
                              hintText: 'Handle (Start with @)'),
                          validator: (val) => val.isEmpty || val[0] != '@'
                              ? 'Invalid Handle!'
                              : null,
                          onChanged: (val) {
                            setState(() => handle = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          width: 250,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                // checking whether content in form is valid
                                setState(() => loading = true);
                                dynamic result =
                                await auth.registerWithEmailAndPassword(
                                    email, password, handle);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  HelperWidgets.flushbar(
                                      'Account already created!', Icons.account_box)
                                    ..show(context);
                                } else {
                                  HelperFunctions.saveUserLoggedInSharedPreferences(
                                      true);
                                  HelperFunctions.saveUserEmailSharedPreferences(
                                      email);
                                  HelperFunctions.saveUsernameSharedPreferences('');
                                  HelperFunctions.saveUserHandleSharedPreferences(
                                      handle);
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                              color: Colors.amberAccent,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  letterSpacing: 1.0,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                          )
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
