import 'package:firebase_database/firebase_database.dart';
import 'package:iddb/services/database/class_database.dart';

class Class {
  var databaseService = ClassesDatabaseService();

  String id = "", name = "", description = "";

  Class();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'description': description,
      };

  Class.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        description = json['description'];

  Future<bool> add() async {
    try {
      await databaseService.setClass(await databaseService.initClass(), this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> update() async {
    try {
      await databaseService.setClass(this.id, this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await databaseService.deleteClass(this.id);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

}
