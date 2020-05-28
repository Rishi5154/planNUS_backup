import 'package:flutter/material.dart';
import 'package:plannusandroidversion/messages/database.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/shared/constants.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:shimmer/shimmer.dart';

class Register extends StatefulWidget {

  // setting the property available for use
  final Function toggleView;
  Register({ this.toggleView });

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
    return loading ?  Loading() : Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Sign in',
              style: new TextStyle(color: Colors.white),
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
              colors: [Colors.amber[100], Colors.deepPurpleAccent, Colors.amber[100]],
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
          child: Form(
            key: formKey, // keep track of form and its state
            child : Column (
              children: <Widget>[
                Image.asset('assets/planNUS.png', height: 250, width: 300),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextFormField(
                    decoration: textInputDecorationPassword.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a longer password!' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextFormField(
                    decoration: textInputDecorationEmail.copyWith(hintText: 'Handle (Start with @)'),
                    validator: (val) => val.isEmpty || val[0] != '@' ? 'Invalid Handle!' : null,
                    onChanged: (val) {
                      setState(() => handle = val);
                    },
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.amberAccent,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                  child: Shimmer.fromColors(
                    highlightColor: Colors.black,
                    baseColor: Colors.white,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      // checking whether content in form is valid
                      setState(() => loading = true);
                      dynamic result = await auth.registerWithEmailAndPassword(email, password, handle);
                      if (result == null) {
                        setState((){
                          error = 'Input valid email & password!';
                          loading = false;
                        });
                      } else {
                        HelperFunctions.saveUserLoggedInSharedPreferences(true);
                        HelperFunctions.saveUserEmailSharedPreferences(email);
                        HelperFunctions.saveUsernameSharedPreferences('');
                        HelperFunctions.saveUserHandleSharedPreferences(handle);
                      }
                    }
                  },
                ),
                SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Colors.yellowAccent, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
