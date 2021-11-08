import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iddb/models/visit.dart';

class VisitsDatabaseService {
  String ref_name = 'visits';

  static final VisitsDatabaseService _singleton =
      VisitsDatabaseService._internal();

  factory VisitsDatabaseService() {
    return _singleton;
  }


  VisitsDatabaseService._internal();

  Future<String> initVisit() async {
    return FirebaseDatabase().reference().child(ref_name).push().key;
    // FirebaseDatabase().reference().child('members/$key').set(m.toJson());
  }

  Future<void> setVisit(String key, Visit m) async {
    m.id = key;
    FirebaseDatabase().reference().child(ref_name + '/$key').set(m.toJson());
  }

  Future<void> deleteVisit(String key) async {
    FirebaseDatabase().reference().child(ref_name + '/$key').remove();
  }

  Future<DatabaseReference> getQuery() async {
    DatabaseReference ref =
        await FirebaseDatabase().reference().child(ref_name);
    return ref;
  }

}
