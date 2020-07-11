import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseMessaging fcm = new FirebaseMessaging();
  String googleEmail = "";
  static GoogleSignInAccount googleSignInAccount;
  static String googleUserId;
  static FirebaseUser currentUser;
  // create user obj based on FireBase User
  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, name: 'no name yet') : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebaseUser);
  }

//  Stream<FirebaseUser> get user {
//    return _auth.onAuthStateChanged;
//  }

  Future login() async {
    String token = await fcm.getToken();
    try{
        GoogleSignInAccount user = await googleSignIn.signIn();
        GoogleSignInAuthentication gsa = await user.authentication;
        final AuthCredential credential = GoogleAuthProvider
            .getCredential(idToken: gsa.idToken, accessToken: gsa.accessToken);
        AuthResult temp = await _auth.signInWithCredential(credential);
        FirebaseUser curr = temp.user;
        googleSignInAccount = user;
        googleUserId = curr.uid;
        currentUser = curr;
        print(currentUser.uid + ": id of current Firebase User, Google Signed in");
        print("true");
        await DatabaseMethods(uid: AuthService.googleUserId).updateNotificationToken(token,googleUserId);
        //await DatabaseMethods(uid: curr.uid).updateUserData('', '@changeHandle');
        return userFromFirebaseUser(curr);
    } catch (err){
      print(err);
      print("null from login");
      return null;
    }
  }

  Future createProfileForGoogleAccounts() async {
    String email = googleSignInAccount.email;
    String name = googleSignInAccount.displayName;
    String token = await fcm.getToken();
//    QuerySnapshot snapshot;
    HelperFunctions.saveUserLoggedInSharedPreferences(true);
    try {
      QuerySnapshot snapshot = await DatabaseMethods().getUserByUserEmail(email);
      //HelperFunctions.saveUserEmailSharedPreferences(email);
      DatabaseMethods().getUserByUserEmail(email).then((value) {
        snapshot = value;
        HelperFunctions
            .saveUsernameSharedPreferences(snapshot.documents[0].data["name"]);
        print(snapshot.documents[0].data["name"]);
        HelperFunctions
            .saveUserHandleSharedPreferences(snapshot.documents[0].data["handle"]);
      });
      print(snapshot.documents[0].data["handle"]); // do not DELETE -> to force the error
      await DatabaseMethods(uid: AuthService.googleUserId).updateNotificationToken(token, googleSignInAccount.id);
    } catch (e) {
      print(e.toString());
      print(AuthService.googleUserId + " at exception");
      String handle = '';
      await DatabaseMethods(uid: AuthService.googleUserId).addUserData(
          email, name, handle);
      await DatabaseMethods(uid: AuthService.googleUserId).updateNotificationToken(token, AuthService.googleUserId);
      HelperFunctions.saveUserEmailSharedPreferences(email);
      HelperFunctions.saveUsernameSharedPreferences(name);
      HelperFunctions.saveUserHandleSharedPreferences(handle);
    }
  }


  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    String token = await fcm.getToken();
    try { // sign in
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      print(user.uid);
      currentUser = user;
      print(currentUser.uid + ": id of current Firebase User with registered account");
      await DatabaseMethods(uid: currentUser.uid).updateNotificationToken(token, currentUser.uid);
      String tkn = await fcm.getToken();
      print(tkn);
      return userFromFirebaseUser(user);
    } catch (e) { // else return null
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String name, String email, String password, String handle) async{
    try { // registration
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String token = await fcm.getToken();
      FirebaseUser user = result.user;
      // create a new collection for the user with id on firebase database
      await DatabaseMethods(uid: user.uid).addUserData(email, name, handle);
      await DatabaseMethods(uid: user.uid).updateNotificationToken(token, user.uid);
      currentUser = user;
      print(currentUser.uid + ": id of current Firebase User with registered account");
      return userFromFirebaseUser(user);
    } catch (e) { // else return null
      print(e.toString());
      return null;
    }
  }

  // reset password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return false;
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