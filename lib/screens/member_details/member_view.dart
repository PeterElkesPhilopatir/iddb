import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iddb/models/member.dart';
import 'package:iddb/screens/member_details/member_profile.dart';
import 'package:iddb/screens/member_details/member_visits.dart';
import 'package:iddb/services/database/member_database.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/messages.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MemberView extends StatefulWidget {
  MemberView({Key? key}) : super(key: key);

  @override
  _MemberViewState createState() => _MemberViewState();
}

class _MemberViewState extends State<MemberView> {
  late Member member;
  @override
  Widget build(BuildContext context) {
    member = (ModalRoute.of(context)!.settings.arguments as Map)['data'] as Member;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              automaticIndicatorColorAdjustment: true,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Profile',
                ),
                Tab(
                  text: 'Visits',
                ),
              ],
            ),
            title: Text(member.name),
            backgroundColor: Colors.red,
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              MemberProfile(member: member,),
              MemberVisits(member: member),
            ],
          ),
        ),
      ),
    );
  }
}
