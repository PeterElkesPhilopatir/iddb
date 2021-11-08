import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iddb/models/class.dart';
import 'package:iddb/models/visit.dart';

class ClassesDatabaseService {
  String ref_name = 'classes';

  static final ClassesDatabaseService _singleton =
  ClassesDatabaseService._internal();

  factory ClassesDatabaseService() {
    return _singleton;
  }


  ClassesDatabaseService._internal();

  Future<String> initClass() async {
    return FirebaseDatabase().reference().child(ref_name).push().key;
    // FirebaseDatabase().reference().child('members/$key').set(m.toJson());
  }

  Future<void> setClass(String key, Class m) async {
    m.id = key;
    FirebaseDatabase().reference().child(ref_name + '/$key').set(m.toJson());
  }

  Future<void> deleteClass(String key) async {
    FirebaseDatabase().reference().child(ref_name + '/$key').remove();
  }

  Future<DatabaseReference> getQuery() async {
    DatabaseReference ref =
        await FirebaseDatabase().reference().child(ref_name);
    return ref;
  }

}
