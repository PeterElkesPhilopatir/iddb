import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/messages.dart';
import 'package:provider/provider.dart';
import '../../models/member.dart';
import 'package:iddb/services/database/member_database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> with TickerProviderStateMixin {
  Member m = Member();
  double margin = 20.0;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.091042248178006, 31.260351453947315),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
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
          title: Text('Add Member'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      _showPickOptionsDialog(context);
                    },
                    child: CircleAvatar(
                      radius: 40,
                      child: _pickedImage == null ? Text("Picture") : null,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                    )),
                SizedBox(
                  height: margin * 3,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                  ),
                  onChanged: (val) {
                    m.name = val;
                  },
                ),

                SizedBox(
                  height: margin,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  onChanged: (val) {
                    m.address = val;
                  },
                ),
                // SizedBox(
                //   height: 300,
                //   child: GoogleMap(
                //     mapType: MapType.hybrid,
                //     initialCameraPosition: _kGooglePlex,
                //     onMapCreated: (GoogleMapController controller) {
                //       _controller.complete(controller);
                //     },
                //   ),
                // ),
                SizedBox(
                  height: margin,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'phone',
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  onChanged: (val) {
                    m.phone = val;
                  },
                ),

                SizedBox(
                  height: margin,
                ),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Landline',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  onChanged: (val) {
                    m.landline = val;
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Birthday Date"),
                  ),
                ),
                Text(m.birthdayString),
                SizedBox(
                  height: 40.0,
                ),
                TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 24.0),
                    child: Text(
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: bdSelectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != bdSelectedDate)
      setState(() {
        bdSelectedDate = selected;
        m.birthdayString =
            "${bdSelectedDate.year}-${bdSelectedDate.month}-${bdSelectedDate.day}";
      });
  }

  _loadPicker(ImageSource source) async {
    PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
    if (picked != null) {
      _cropImage(picked);
    }
    // Navigator.pop(context);
  }

  _cropImage(PickedFile? picked) async {
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.red,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
      });
      MemberDatabaseService()
          .uploadProfileImage(context, _pickedImage!)
          .then((value) => {m.imageURL = value, showToast('photo uploaded')});
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              leading: Icon(Icons.file_copy),
              onTap: () {
                _loadPicker(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take a picture"),
              onTap: () {
                _loadPicker(ImageSource.camera);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _onAddClicked(String class_id) async {
    m.class_id = class_id;
    m.add().then((value) => value
        ? {showToast('Added'), Navigator.pop(context)}
        : showToast('failed'));
  }
}
