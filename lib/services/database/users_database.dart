import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/models/visit.dart';

class UsersDatabaseService {
  String ref_name = 'users';

  static final UsersDatabaseService _singleton =
  UsersDatabaseService._internal();

  factory UsersDatabaseService() {
    return _singleton;
  }

  UsersDatabaseService._internal();

  Future<String> initUser() async {
    return FirebaseDatabase().reference().child(ref_name).push().key;
    // FirebaseDatabase().reference().child('members/$key').set(m.toJson());
  }

  Future<void> set(String key, MyUser m) async {
    m.id = key;
    FirebaseDatabase().reference().child(ref_name + '/$key').set(m.toJson());
  }

  Future<void> delete(String key) async {
    FirebaseDatabase().reference().child(ref_name + '/$key').remove();
  }

  Future<DatabaseReference> getQuery() async {
    DatabaseReference ref =
        await FirebaseDatabase().reference().child(ref_name);
    return ref;
  }

  Future<MyUser> getUser(String loginId) async {
    MyUser user = MyUser(login_id: '');

    await FirebaseDatabase()
        .reference()
        .child('users')
        .orderByChild('login_id')
        .equalTo(loginId)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, v) => {
        user.id = key,
        user.login_id = v['login_id'],
        user.password = v['password'],
        user.email = v['email'],
        user.type = v['type'],
        user.class_id = v['class_id'],
        user.phone = v['phone'],
        user.photoUrl = v['photoUrl'],
        user.birthday = v['birthday'],
      });
    });
    return user;
  }


}
