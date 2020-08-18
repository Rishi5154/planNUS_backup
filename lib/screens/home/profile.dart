import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/helperwidgets.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

//  final AuthService auth = AuthService();
  User user;
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
  String newHandle;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot currentUser;

  bool gotName;

  StorageReference reference;

  getPhoto() async {
    if (Constants.myProfilePhoto == null) {
      try {
        url = await downloadImage();
        print(url.toString() + " is null???");
        setState(() {
          img = Image.network(url);
        });
      } catch (e) {
        print("here at img fail");
        print(e.toString());
        setState(() {
          img = Image.asset(
            'assets/profilepicture.png', height: 300, width: 300,);
        });
      }
    } else {
      setState(() {
        img = Constants.myProfilePhoto;
      });
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = new ImagePicker();
    PickedFile img = await imagePicker.getImage(source: ImageSource.gallery);
//    File image = File(img.path);
    if (img != null) {
      File image =
      await ImageCropper.cropImage(sourcePath: img.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepPurpleAccent,
              toolbarTitle: "Image cropper",
              statusBarColor: Colors.deepPurple.shade500,
              backgroundColor: Colors.white
          ));
      //File image = File(img.path);
      await uploadImage(image);
      setState(() {
        _image = image;
        Constants.myProfilePhoto = Image.file(image);
      });
      return image;
    }
  }

  Future uploadImage(File image) async {
    StorageUploadTask uploadTask = reference.putFile(image);
    print(AuthService.currentUser.uid + " here at image.dart");
    await uploadTask.onComplete;
  }

  Future downloadImage() async {
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  getRef() async {
//    setState(() async {
      reference = FirebaseStorage.instance.ref().child('${AuthService.currentUser.uid}/profileimage.jpg');
//    });
  }

  @override
  void initState() {
    getRef();
    getPhoto();
    print(TimeOfDay.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    reference = FirebaseStorage.instance.ref().child('${user.uid}/profileimage.jpg');
    handle = Provider.of<String>(context);
    return handle == null || img == null
      ? Loading()
      : Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Center(
              child: Text("Welcome, " + handle,
                  style: GoogleFonts.openSans(color: Colors.white,fontSize: 20)
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
                  end: new Alignment(-1, -1),
                  colors: [Colors.deepPurple[800], Colors.purpleAccent[700], Colors.deepPurple[300]],
                ),
              ),
              child: Form(
                key: formKey, // keep track of form and its state
                child : Column (
                  children: <Widget>[
                    Container(
                        child:
//                        CachedNetworkImage(
//                          imageUrl: url ?? '',
//                          placeholder: (context, url) => Padding(
//                            padding: const EdgeInsets.all(60.0),
//                            child: CircularProgressIndicator(),
//                          ),
//                          imageBuilder: (context, imageprovider) => Padding(
//                            padding: const EdgeInsets.only(left: 6, top: 0, right: 0, bottom: 0),
//                            child: CircleAvatar(backgroundImage: imageprovider, radius: 100,),
//                          ),
//                          errorWidget: (context, url, error) => Padding(
//                            padding: const EdgeInsets.all(60),
//                            child: Container(
//                              decoration: BoxDecoration(
//                                color: Colors.blue,
//                                borderRadius: BorderRadius.circular(100),
//                              ),
//                              child: CircleAvatar(
//                                  backgroundImage: Constants.myProfilePhoto.image,
//                                  radius: 100),
//                            ),
//                          ),

                        _image != null ? Padding(
                          padding: const EdgeInsets.all(60),
                          child: CircleAvatar(backgroundImage:FileImage(_image), radius: 100),
                        ) :
                        url != null ? Padding(
                          padding: const EdgeInsets.all(60),
                          child: CircleAvatar(backgroundImage:img.image, radius: 100),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(60),
                          child: CircleAvatar(backgroundImage:Constants.myProfilePhoto.image, radius: 100),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Constants.myName == null || Constants.myName.isEmpty ? TextFormField(
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
                      ) : Container(height: 10,),
                    ),
                    SizedBox(height: Constants.myName == null || Constants.myName.isNotEmpty ? 5 : 20),
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      child: TextFormField(
                        key: Key('Name-field'),
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
                        validator: (val) => val[0] != '@' || val.isEmpty ? 'Handle starts with @!' : null,
                        onChanged: (val) {
                            setState(() => newHandle = val);
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
                                /*if (newHandle == null|| name == null) {
                                  print("are you here!");
                                  HelperWidgets.TopFlushbar("You have missing fields", Icons.account_circle)..show(context);
                                } else */if (formKey.currentState.validate()) {
                                  await databaseMethods.updateSpecificUserData(
                                      user.uid, name, newHandle);
                                  if (name.isNotEmpty) {
                                    HelperFunctions.saveUsernameSharedPreferences(name);
                                    await user.changeName(name);
                                    Constants.myName = name;
                                  }
                                  HelperFunctions.saveUserHandleSharedPreferences(
                                      handle);
                                  Constants.myHandle = handle;
                                  print(Constants.myName);
                                  print(Constants.myHandle);
                                  setState(() {
                                    key = handle;
                                  });
                                  HelperWidgets.flushbar('Update successful!', Icons.update)..show(context);
                                }
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3, right:0, top: 0, bottom: 0),
                          child: RaisedButton(
                            onPressed: () async {
//                              File curr = await getImage();

////                              ImagePicker imagePicker = new ImagePicker();
////                              PickedFile img = await imagePicker.getImage(source: ImageSource.gallery);
////                              File image = File(img.path);
//                              setState(() async {
//                                File curr = await getImage();
////                                _image = image;
////                                Constants.myProfilePhoto = Image.file(image);
//                              });
//                              ImagePicker imagePicker = new ImagePicker();
//                              PickedFile img = await imagePicker.getImage(source: ImageSource.gallery);
//                              File image = File(img.path);
//                              setState(() {
//                                _image = image;
//                                Constants.myProfilePhoto = Image.file(image);
//                              });
//                              await uploadImage(image);
//                              //Constants.myProfilePhoto = Image.file(image);
//                              print(user.uid + " is here after all time");
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
                    SizedBox(height: Constants.myName.isNotEmpty ? 50 : 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height - 707 > 0 ? MediaQuery.of(context).size.height - 707 : 0)
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
