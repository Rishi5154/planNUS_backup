import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannusandroidversion/models/user.dart';

class DatabaseMethods {
  final String uid;
  DatabaseMethods({this.uid});

  final CollectionReference users = Firestore.instance.collection("users");
  
  Stream<User> getUserStream2() {
    return users.document(uid).snapshots().map((ss) => User.fromJson(ss.data['user']));
  }
  
  Future<User> getUserData1() async {
    return await users.document(uid).get().then((ss) => ss['user']);
  }

  Future<void> updateUserData2(User userData) async {
    return await users.document(uid).updateData({
      'user' : userData.toJson()
    });
  }

  Future<void> addUserData(String email, String name, String handle) async {
    print(uid);
    return await users.document(uid).setData({
      'email' : email,
      'name' : name,
      'handle' : handle,
      'user' : User(uid: uid).toJson()
    });
  }

  Future<void> updateUserData(String email, String name, String handle) async {
    print(uid);
    return await users.document(uid).updateData({
      'email' : email,
      'name' : name,
      'handle' : handle,
    });
  }

  Future<void> updateSpecificUserData(String uid, String name, String handle) async {
    print(uid + " here");
    print(handle.isEmpty);
    return await users.document(uid).updateData({
      'name' : name,
      'handle' : handle,
    });
  }

  Future<String> getSpecificUserData(String uid) async {
    String user;
    await users.document(uid).get().then((value) => {
      user = value['handle']
    });
    //print(user);
    return user;
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  Future<QuerySnapshot> getUserByHandle(String handle) async {
    return await users.where("handle", isEqualTo: handle).getDocuments();
  }
  Future<QuerySnapshot> getUserByName(String name) async {
    return await users.where("name", isEqualTo: name).getDocuments();
  }

  Future<QuerySnapshot> getUserByUserEmail(String email) async {
    return await users.where("email", isEqualTo: email).getDocuments();
  }

  Future<DocumentSnapshot> getHandleByEmail(String uid) async {
    return await users.document(uid).get();
  }

  // user data from snapshot
  Stream<QuerySnapshot> get userInfo {
    return users.snapshots();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((onError){
      print(onError.toString());
    });
  }

  updateChatRoom(String chatRoomID, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .updateData(chatRoomMap)
        .catchError((onError){
          print(onError.toString());
        });
  }

  addConversationMessages(String chatRoomID, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomID) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String name) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: name)
        .snapshots();
  }

  //##########################//

}