import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plannusandroidversion/messages/database.dart';
import 'package:plannusandroidversion/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  String googleEmail = "";
  static GoogleSignInAccount googleSignInAccount;
  static String googleUserId;
  static FirebaseUser currentUser;


  // create user obj based on FireBase User
  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebaseUser);
  }

  Future login() async {
    try{
        GoogleSignInAccount user = await googleSignIn.signIn();
        GoogleSignInAuthentication gsa = await user.authentication;
        final AuthCredential credential = GoogleAuthProvider
            .getCredential(idToken: gsa.idToken, accessToken: gsa.accessToken);
        AuthResult temp = await _auth.signInWithCredential(credential);
        FirebaseUser curr = temp.user;
        googleSignInAccount = user;
        googleUserId = curr.uid;
        print("true");
        //await DatabaseMethods(uid: curr.uid).updateUserData('', '@changeHandle');
        return userFromFirebaseUser(curr);
    } catch (err){
      print(err);
      print("null from login");
      return null;
    }
  }

  Future createProfileForGoogleAccounts() async {
    try {
      QuerySnapshot snapshot = await DatabaseMethods().getUserByUserEmail(
          AuthService.googleSignInAccount.email);
      print(snapshot.documents[0].data['name']);
      print("here at Gsignin");
      print(AuthService.googleUserId);
    } catch (e) {
      print(e.toString());
      print(AuthService.googleUserId + " at exception");
      await DatabaseMethods(uid: AuthService.googleUserId).addUserData(
          AuthService.googleSignInAccount.email,
          AuthService.googleSignInAccount.displayName, '');
    }
  }

  // sign in anon
  Future signInAnon() async {
    // try and sign in, return user if found,
    // else catch the error when logging then return null
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try { // sign in
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      print(user.uid);
      currentUser = user;
      return userFromFirebaseUser(user);
    } catch (e) { // else return null
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String handle) async{
    try { // registration
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new collection for the user with id on firebase database
      await DatabaseMethods(uid: user.uid).addUserData(email, '', handle);
      currentUser = user;
      return userFromFirebaseUser(user);
    } catch (e) { // else return null
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // google sign out
  Future googleSignOut() async {
    try {
      return await googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}