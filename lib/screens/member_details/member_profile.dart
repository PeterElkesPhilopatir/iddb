import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iddb/models/member.dart';
import 'package:iddb/services/database/member_database.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/messages.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MemberProfile extends StatefulWidget {
  Member member;

  MemberProfile({Key? key, required this.member}) : super(key: key);

  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
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
    var nameTxt = TextEditingController();
    var addressTxt = TextEditingController();
    var landLineTxt = TextEditingController();
    var phoneTxt = TextEditingController();
    var birthdayTxt = TextEditingController();
    nameTxt.text = widget.member.name;
    addressTxt.text = widget.member.address;
    landLineTxt.text = widget.member.landline;
    phoneTxt.text = widget.member.phone;
    birthdayTxt.text = widget.member.birthdayString;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          children: <Widget>[
            InkWell(
                onTap: () {
                  _showPickOptionsDialog(context);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      image: DecorationImage(
                        image: _pickedImage != null
                            ? FileImage(_pickedImage!) as ImageProvider
                            : NetworkImage(widget.member.imageURL) as ImageProvider,
                      ),
                    ))),
            SizedBox(
              height: margin * 3,
            ),
            TextFormField(
              controller: nameTxt,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
              ),
              onChanged: (val) {
                widget.member.name = val;
              },
            ),

            SizedBox(
              height: margin,
            ),
            TextFormField(
              controller: addressTxt,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              onChanged: (val) {
                widget.member.address = val;
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

              controller: phoneTxt,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'phone',
                prefixIcon: Icon(Icons.phone_android),
              ),
              onChanged: (val) {
                widget.member.phone = val;
              },
            ),
            SizedBox(
              height: margin,
            ),

            TextFormField(
              controller: landLineTxt,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Landline',
                prefixIcon: Icon(Icons.phone),
              ),
              onChanged: (val) {
                widget.member.landline = val;
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
            Text(widget.member.birthdayString),

            SizedBox(
              height: 40.0,
            ),
            TextButton(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                child: Text(
                  'Save',
                ),
              ),
              onPressed: () {
                _onSaveClicked();
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
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      initialDate: bdSelectedDate,
    );
    if (selected != null && selected != bdSelectedDate)
      setState(() {
        bdSelectedDate = selected;
        widget.member.birthdayString =
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
      MemberDatabaseService().uploadProfileImage(context, _pickedImage!).then(
          (value) => {widget.member.imageURL = value, showToast('photo uploaded')});
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

  void _onSaveClicked() async {
    widget.member.update().then((value) => value
        ? {showToast('Saved')}
        : showToast('failed'));
  }
}
