import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iddb/models/class.dart';
import 'package:iddb/models/member.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:iddb/shared/loading.dart';
import 'package:iddb/shared/nav_drawer.dart';
import 'package:provider/provider.dart';
import 'class_list.dart';
import 'member_item.dart';

class HomeServant extends StatefulWidget {
  @override
  State<HomeServant> createState() => _HomeServantState();
}

class _HomeServantState extends State<HomeServant> {
  List members = <Member>[];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Deacons'),
        backgroundColor: Colors.red,
        elevation: 20.0,
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("members")
              .orderByChild('class_id')
              .equalTo(user.class_id)
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              try {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;

                members.clear();

                Member p;
                map.forEach((key, v) => {
                      p = Member(),
                      p.id = key,
                      p.latitude = v['latitude'],
                      p.langitude = v['langitude'],
                      p.address = v['address'],
                      p.phone = v['phone'],
                      p.landline = v['landline'],
                      p.name = v['name'],
                      p.imageURL = v['imageURL'],
                      p.birthdayString = v['birthdayString'],
                      members.add(p),
                    });

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: members.length,
                  padding: EdgeInsets.all(2.0),
                  itemBuilder: (BuildContext context, int index) {
                    return MemberWidget(member: members[index]);
                  },
                );
              } catch (e) {
                print(e);
                return Scaffold(
                  body: Center(
                    child: Text('No Members Added'),
                  ),
                );
              }
            } else {
              return Center(child: Loading());
            }
          }),
      drawer: NavDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onAddClicked();
        },
        backgroundColor: Colors.red,
        label: Text('Add'),
        icon: Icon(Icons.person_add),
      ),
    );
  }

  void onAddClicked() {
    Navigator.pushNamed(context, '/add_member');
    // showDialog();
  }

  StreamBuilder<Event> bodyIfServant(String? class_id) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("members")
            .orderByChild('class_id')
            .equalTo(class_id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            try {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;

              members.clear();

              Member p;
              map.forEach((key, v) => {
                    p = Member(),
                    p.id = key,
                    p.latitude = v['latitude'],
                    p.langitude = v['langitude'],
                    p.address = v['address'],
                    p.phone = v['phone'],
                    p.landline = v['landline'],
                    p.name = v['name'],
                    p.imageURL = v['imageURL'],
                    p.birthdayString = v['birthdayString'],
                    members.add(p),
                  });

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: members.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return MemberWidget(member: members[index]);
                },
              );
            } catch (e) {
              print(e);
              return Scaffold(
                body: Center(
                  child: Text('No Members Added'),
                ),
              );
            }
          } else {
            return Center(child: Loading());
          }
        });
  }
}
