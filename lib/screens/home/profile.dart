import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>(); // 'id' of form
  bool loading = false;
  // text field state
  String name = '';
  String password = '';
  String handle;
  String error = '';
  String key = '';
  String url;
  Image img;
  File _image;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot currentUser;
  StorageReference reference = FirebaseStorage.instance.ref()
      .child('${AuthService.currentUser.uid}/profileimage.jpg');

  profileName(String uid) async{
    await databaseMethods
        .getHandleByEmail(uid)
        .then((value) => {
      setState(() => handle = value['handle'])
    });
  }
  displayHandle() async {
    await auth.googleSignIn.isSignedIn() ? profileName(AuthService.googleUserId)
        : profileName(AuthService.currentUser.uid);
  }
  getPhoto() async {
    try {
      url = await downloadImage();
      setState(() {
        img = Image.network(url);
      });
    } catch (e) {
      print("here at img fail");
      setState(() {
        img = Image.asset('assets/profilepicture.png', height: 300, width: 300,);
      });
    }
  }

  Future getImage() async {
    print(AuthService.currentUser.uid + " here at image.dart");
    File Image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
//    setState(() {
//      _image = Image;
//    });
    await uploadImage(Image);
    return Image;
  }

  Future uploadImage(File image) async {
    StorageUploadTask uploadTask = reference.putFile(image);
    print(AuthService.currentUser.uid + " here at image.dart");
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  }

  Future downloadImage() async {
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
    //Image img = Image
    //StorageReference img = await FirebaseStorage.instance.getReferenceFromUrl(downloadUrl)
  }


  @override
  void initState() {
    // TODO: implement initState
    getPhoto();
    displayHandle();
    super.initState();
  }

//  Future getImage() async {
//    ImagePicker imagePicker = new ImagePicker();
//    File Image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    //PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
//    setState(() {
//      _image = Image;
//    });
//    uploadImage(Image);
//  }
//
//  Future uploadImage(File image) async {
//    StorageUploadTask uploadTask = reference.putFile(image);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//  }
//
//  Future downloadImage() async {
//    String downloadUrl = await reference.getDownloadURL();
//    return downloadUrl;
//  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return handle == null || img == null ? Loading() : Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text("Welcome, " + handle,
              style: TextStyle(color: Colors.black)
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurpleAccent, Colors.white70, Colors.deepPurple],
            ),
          ),
          child: Form(
            key: formKey, // keep track of form and its state
            child : Column (
              children: <Widget>[
                Container(
                  child: _image != null ? Padding(
                    padding: const EdgeInsets.all(60),
                    child: CircleAvatar(backgroundImage:FileImage(_image), radius: 100),
                  ) :
                    url != null ? Padding(
                      padding: const EdgeInsets.all(60),
                      child: CircleAvatar(backgroundImage:img.image, radius: 100),
                    )
                        : img
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Name',
                        icon: Icon(Icons.person_outline, color: Colors.blue),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300], width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        )
                    ),
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Handle',
                        icon: Icon(Icons.alternate_email, color: Colors.blue),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300], width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        )
                    ),
                    obscureText: false,
                    validator: (val) => val[0] != '@' ? 'Handle starts with @!' : null,
                    onChanged: (val) {
                      setState(() => handle = val);
                      //print(handle);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    Container(
                      margin: EdgeInsets.only(left: 10, right:0, top: 0, bottom: 0),
                      child: RaisedButton(
                        color: Colors.blueAccent,
                        child: Shimmer.fromColors(
                          highlightColor: Colors.black,
                          baseColor: Colors.white,
                          child: Text(
                            'Update',
                            style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                        onPressed: () async {
                          //print(handle);
                          if (formKey.currentState.validate()) {
                            print(AuthService.googleUserId);
                            bool check = await auth.googleSignIn.isSignedIn();
                            if (check) {
                              await databaseMethods.updateSpecificUserData(
                                  AuthService.googleUserId, name, handle);
                            } else {
                              await databaseMethods.updateSpecificUserData(
                                  user.uid, name, handle);
                            }
                            HelperFunctions.saveUsernameSharedPreferences(name);
                            HelperFunctions.saveUserHandleSharedPreferences(handle);
                            Constants.myName = name;
                            Constants.myHandle = handle;
                            print(Constants.myName);
                            print(Constants.myHandle);
                            setState(() {
                              error = 'Update successful!';
                              key = handle;
                            });
                          }
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right:0, top: 0, bottom: 0),
                      child: RaisedButton(
                        onPressed: () async {
                          ImagePicker imagePicker = new ImagePicker();
                          File Image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          //File image = await ImageSelector.getImage();
                          setState(() {
                            _image = Image;
                          });
                          await uploadImage(Image);

                        },
                        color: Colors.blueAccent,
                        child: Shimmer.fromColors(
                          highlightColor: Colors.black,
                          baseColor: Colors.white,
                          child: Text(
                            'Update image',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
