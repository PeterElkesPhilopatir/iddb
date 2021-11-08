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

class HomeManager extends StatefulWidget {
  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  List members = <Member>[];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Classes'),
        backgroundColor: Colors.red,
        elevation: 20.0,
      ),
      body: Center(
        child: Text("Manager"),
      ),
      drawer: NavDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onAddClicked();
        },
        backgroundColor: Colors.red,
        label: Text('Add New Class'),
        icon: Icon(Icons.group_add),
      ),
    );
  }

  void onAddClicked() {
    Navigator.pushNamed(context, '/add_class');
  }
}
