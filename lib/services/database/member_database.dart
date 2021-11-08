import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../../models/member.dart';
import 'package:image_picker/image_picker.dart';

class MemberDatabaseService {
  String ref_name = 'members';
  // collection reference
  static final MemberDatabaseService _singleton = MemberDatabaseService._internal();

  factory MemberDatabaseService() {
    return _singleton;
  }

  MemberDatabaseService._internal();


  // Future<bool> addMember(Member m) async {
  //   try {
  //     final modelRef = membersCollection.withConverter<Member>(
  //       fromFirestore: (snapshot, _) => Member.fromJson(snapshot.data()!),
  //       toFirestore: (model, _) => model.toJson(),
  //     );
  //     modelRef.add(m);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  Future<String> initMember() async {
    return FirebaseDatabase().reference().child(ref_name).push().key;
  }

  Future<void> setMember(String key, Member m) async {
    m.id = key;
    FirebaseDatabase().reference().child(ref_name+'/$key').set(m.toJson());
  }

  Future uploadProfileImage(BuildContext context, File image_file) async {
    String url = "";
    String fileName = image_file.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/profile/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(image_file);
    TaskSnapshot taskSnapshot = await uploadTask;
    url = await taskSnapshot.ref.getDownloadURL();
    return Future.value(url);
  }

  Future<Stream<Event>> getMembersQuery() async {
        return FirebaseDatabase().reference().child(ref_name).onValue;
  }

}
