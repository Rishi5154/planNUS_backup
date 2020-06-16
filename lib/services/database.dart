import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannusandroidversion/models/timetable.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';

class DatabaseMethods {
  final String uid;
  DatabaseMethods({this.uid});

  final CollectionReference users = Firestore.instance.collection("users");
  final CollectionReference tokens = Firestore.instance.collection("userNotificationTokens");

  Stream<String> getHandleStream() {
    return users.document(uid).snapshots().map((ss) => ss.data['handle']);
  }

  Stream<User> getUserStream2() {
    return users.document(uid).snapshots().map((ss) => User.fromJson(ss.data['user']));
  }

  Stream<User> getUserStreamByUid(String uid) {
    return users.document(uid).snapshots().map((ss) => User.fromJson(ss.data['user']));
  }
  
  Stream<TodoData> getUserTodoDataStream() {
    return users.document(uid).snapshots().map((ss) => TodoData.fromJson(ss.data['tasks']));
  }

//  Future<User> getOtherUserViaHandle(String handle) {
//    QuerySnapshot snapshot;
//    print(handle);
//    users.where("handle", isEqualTo: handle).getDocuments().then((value) => snapshot);
//    return snapshot.hasData ? snapshot.documents.first.data['user'];
//    //return snapshot.me.documents[0].data['user'];
//  }

  Future<void> updateUserTodoData(TodoData data) async {
    return users.document(uid).updateData({
      'tasks' : data.toJson()
    });
  }

  Future<TodoData> getUserTodoData() async {
    TodoData result = await users.document(uid).get().then((val) => TodoData.fromJson(val['tasks']));
    return result;
  }

  Future<void> updateUserData2(User userData) async {
    return await users.document(uid).updateData({
      'user' : userData.toJson()
    });
  }

  Future<TimeTable> getUserTimetable(String uid) async {
    TimeTable userTimetable = await users.document(uid).get()
        .then((val) => TimeTable.fromJson(val['user']['timetable']));
    return userTimetable;
  }


  Future<void> addUserData(String email, String name, String handle) async {
    print(uid);
    return await users.document(uid).setData({
      'email' : email,
      'name' : name,
      'handle' : handle,
      'user' : User(uid: uid, name: name).toJson(),
      'tasks' : TodoData().toJson(),
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

  Future<void> updateNotificationToken(String token, String uid) async {
    return await tokens.document(uid).setData({
      'token' : token
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

//  Future<User> getUserDataByHandle(String handle) async {
//    return await users.where("handle", isEqualTo: handle).getDocuments();
//  }

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
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String name) async {
    return Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: name)
        .snapshots();
  }

  //##########################//

}