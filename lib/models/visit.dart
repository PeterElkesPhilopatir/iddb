import 'package:iddb/services/database/visits_database.dart';

class Visit {
  var databaseService = VisitsDatabaseService();

  late String id = "", date = "", notes = "", member_id = "", servant_id = "", type = VisitType.undefined;

  Visit() {}

  Map<String, dynamic> toJson() => {
        'date': date,
        'id': id,
        'notes': notes,
        'member_id': member_id,
        'servant_id': servant_id,
        'type': type,
      };

  Future<bool> add() async {
    try {
      await databaseService.setVisit(await databaseService.initVisit(), this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> update() async {
    try {
      await databaseService.setVisit(this.id, this);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await databaseService.deleteVisit(this.id);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class VisitType {
 static const String undefined = 'undefined';
 static const String mobile = 'mobile';
 static const String home = 'home_servant';
}
