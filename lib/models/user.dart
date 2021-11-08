import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:iddb/services/database/users_database.dart';

class MyUser {
  var databaseService = UsersDatabaseService();

  String? login_id;
  String? id;
  String? phone;
  String? photoUrl =
      "https://firebasestorage.googleapis.com/v0/b/iddb-3d33d.appspot.com/o/uploads%2Fprofile%2Fdata%2Fuser%2F0%2Fcom.iddb%2Fcache%2Fuser.png?alt=media&token=4003bfb4-b534-4578-964b-e592dfef12c3";
  String? email;
  String? type = UserType.UNDEFINED;
  String? class_id;
  String? birthday;
  String? password;

  // bool verified = false;
  Future<MyUser> init() async {
    // await build();
    print('data');
    MyUser u = MyUser(login_id: login_id!);
    await FirebaseDatabase()
        .reference()
        .child('users')
        .orderByChild('login_id')
        .equalTo(login_id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, v) => {
            print('data'),
            print(v),
            u.id = key,
            u.login_id = v['login_id'],
            u.password = v['password'],
            u.email = v['email'],
            u.type = v['type'],
            u.class_id = v['class_id'],
            u.phone = v['phone'],
            u.photoUrl = v['photoUrl'],
            u.birthday = v['birthday'],
          });
    });
    return u;
  }

  MyUser({required String login_id}) {
    this.login_id = login_id;
    // if (this.login_id != '') init();
    if (this.login_id != '') build();

  }

  Map<String, dynamic> toJson() => {
        'login_id': login_id,
        'id': id,
        'phone': phone,
        'photoUrl': photoUrl,
        'email': email,
        'class_id': class_id,
        'type': type,
        'birthday': birthday,
        'password': password,
      };

  Future<bool> add() async {
    try {
      await databaseService.set(await databaseService.initUser(), this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> update() async {
    try {
      await databaseService.set(id!, this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await databaseService.delete(id!);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> build() async {
    await FirebaseDatabase()
        .reference()
        .child('users')
        .orderByChild('login_id')
        .equalTo(login_id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, v) => {
            id = key,
            login_id = v['login_id'],
            password = v['password'],
            email = v['email'],
            type = v['type'],
            class_id = v['class_id'],
            phone = v['phone'],
            photoUrl = v['photoUrl'],
            birthday = v['birthday'],
          });
    });
  }
}

class UserType {
  static const String UNDEFINED = "undefined";
  static const String BOY = "boy";
  static const String SERVANT = "servant";
  static const String MANAGER = "manager";
  static const String GeneralManager = "general_manager";
  static const String ADMIN = "admin";
}
