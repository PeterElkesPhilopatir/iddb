import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iddb/models/class.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/messages.dart';
import 'package:provider/provider.dart';
import '../../models/member.dart';
import 'package:iddb/services/database/member_database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> with TickerProviderStateMixin {
  Class c = Class();
  double margin = 20.0;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(30.091042248178006, 31.260351453947315),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = const CameraPosition(
      bearing: 192.8334901395799,
      target: const LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  DateTime bdSelectedDate = DateTime.now();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Class'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[

                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                  ),
                  onChanged: (val) {
                    c.name = val;
                  },
                ),

                SizedBox(
                  height: margin,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  onChanged: (val) {
                    c.description = val;
                  },
                ),


                const SizedBox(
                  height: 40.0,
                ),
                TextButton(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 24.0),
                    child: const Text(
                      'Add',
                    ),
                  ),
                  onPressed: () {
                    _onAddClicked(user.class_id!);
                  },
                  style: getRounded(),
                )
              ],
            ),
          ),
        ));
  }

  void _onAddClicked(String class_id) async {
    c.add().then((value) => value
        ? {showToast('Added'), Navigator.pop(context)}
        : showToast('failed'));
  }
}
