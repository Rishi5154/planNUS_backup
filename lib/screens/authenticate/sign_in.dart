import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/screens/authenticate/resetpassword.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/constants.dart';
import 'package:plannusandroidversion/shared/helperwidgets.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:shimmer/shimmer.dart';

class SignIn extends StatefulWidget {
  // setting the property available for use
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>(); // 'id' of form
  bool loading = false;


  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: Key('sign in page'),
            backgroundColor: Colors.deepPurpleAccent[700],
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.deepPurpleAccent[700],
                            Colors.deepPurpleAccent[100],
                            Colors.deepPurple
                          ],
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset('assets/plannusupgraded.png',
                                  height: 250, width: 500,scale: 0.00001,),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(right: 30),
                              child: TextFormField(
                                key: Key('Email-form key'),
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
                                key: Key('Password-form key'),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 25,
                                width: 250,
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ResetPassword(),
                                    ));
                                  },
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.black,
                                    child: Text(
                                      'Forgot password?',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              width: 250,
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    QuerySnapshot userInfoSnapshot;
                                    if (formKey.currentState.validate()) {
                                      HelperFunctions.saveUserEmailSharedPreferences(
                                          email);
                                      DatabaseMethods()
                                          .getUserByUserEmail(email)
                                          .then((value) {
                                        userInfoSnapshot = value;
                                        HelperFunctions.saveUsernameSharedPreferences(
                                            userInfoSnapshot
                                                .documents[0].data["name"]);
                                        print(userInfoSnapshot
                                            .documents[0].data["name"]);
                                        HelperFunctions
                                            .saveUserHandleSharedPreferences(
                                                userInfoSnapshot
                                                    .documents[0].data["handle"]);
                                      });
                                      //NEWLY ADDED 22 July 2020 12:44//
                                      await DatabaseMethods()
                                          .getUserByUserEmail(email)
                                          .then((value) =>
                                          DatabaseMethods().getUserByUID(value.documents[0].documentID))
                                          .then((user) => user.getReviewNotice());
                                      //^^^^^^^^^^ To add notifications of to-review events that has been completed :)
                                      setState(() => loading = true);
                                      dynamic result =
                                          await auth.signInWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        HelperWidgets.flushbar(
                                            'FAILED TO SIGN IN!', Icons.account_box)
                                          ..show(context);
                                      } else {
                                        print("here at signin");
                                        HelperFunctions
                                            .saveUserLoggedInSharedPreferences(true);
                                        await Constants.setAll();
//                                        Constants.myName = await HelperFunctions
//                                            .getUsernameSharedPreferences();
//                                        Constants.myHandle = await HelperFunctions
//                                            .getUserHandleSharedPreferences();
                                        //Constants.myProfilePhoto = await ImageSelector.downloadImage() ?? '';
                                        print(Constants.myName + " has logged in");
                                        print(Constants.myHandle + " has logged in");
                                      }
                                    } else {
                                      HelperFunctions
                                          .saveUserLoggedInSharedPreferences(true);
                                    }
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.amberAccent,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    letterSpacing: 1.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            HelperWidgets.buildSignInWithText(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  HelperWidgets.buildSocialBtn(
                                    () async {
                                      setState(() => loading = true);
                                      print("here");
                                      dynamic result = await auth.login();
                                      if (result == null || result == false) {
                                        setState(() {
                                          loading = false;
                                        });
                                        HelperWidgets.flushbar(
                                            'FAILED TO SIGN IN!', Icons.account_box)
                                          ..show(context);
                                      } else {
                                        auth.createProfileForGoogleAccounts();
                                        await Constants.setAll();
                                      }
                                    },
                                    AssetImage(
                                      'assets/google.jpg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height - 655,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FlatButton.icon(
                      icon: Icon(Icons.person, color: Colors.white),
                      label: Text(
                        'Register',
                        softWrap: true,
                        style: GoogleFonts.biryani(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ),
                )
              ]
          ),
      );
  }
}
