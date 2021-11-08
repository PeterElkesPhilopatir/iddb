import 'package:iddb/services/database/member_database.dart';

class Member {
  var databaseService = MemberDatabaseService();

  late String id = "",
      name = "",
      phone = "",
      landline = "",
      address = "",
      langitude = "",
      latitude = "",
      class_id = "",
      imageURL =
          "https://firebasestorage.googleapis.com/v0/b/iddb-3d33d.appspot.com/o/uploads%2Fprofile%2Fdata%2Fuser%2F0%2Fcom.iddb%2Fcache%2Fuser.png?alt=media&token=4003bfb4-b534-4578-964b-e592dfef12c3",
      birthdayString = "";
  late DateTime birthday = DateTime.now();

  Member() {}

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'phone': phone,
        'landline': landline,
        'address': address,
        'langitude': langitude,
        'latitude': latitude,
        'imageURL': imageURL,
        'class_id': class_id,
        'birthdayString': birthdayString,
      };

  Member.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        phone = json['phone'],
        landline = json['landline'],
        address = json['address'],
        langitude = json['langitude'],
        latitude = json['latitude'],
        birthdayString = json['birthdayString'],
        class_id = json['class_id'],
        imageURL = json['imageURL'];

  Future<bool> add() async {
    try {
      await databaseService.setMember(await databaseService.initMember(), this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> update() async {
    try {
      await databaseService.setMember(this.id, this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
