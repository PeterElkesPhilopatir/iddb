
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/messages.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 20.0,
      ),
      body: RegisterBody(),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  DateTime bdSelectedDate = DateTime.now();
  File? _pickedImage;
  String msg ="";
  MyUser user = MyUser(login_id: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                SizedBox(
                  height: 20.0,
                ),
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
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      (val!.isEmpty) ? 'Email is not valid' : null,
                  onChanged: (val) {
                    setState(() => user.email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  validator: (val) =>
                      val!.length < 0 ? 'Enter a password 8+ chars long' : null,
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (val) {
                    setState(() => user.password = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                  onChanged: (val) {
                    setState(() => user.phone = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                    child: Text(
                      'Register',
                    ),
                    onPressed: () {
                      onRegisterPressed();
                    },
                    style: getRounded(),),
              ],
            ),
          )),
    );
  }

  bool validateEmailRegex() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(user.email!);
  }

  Future<void> onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      print(user.email! + "//" + user.password!);
      MyUser result =
          await _auth.registerWithEmailAndPassword(user.email!, user.password!);
      if (result.login_id == '') {
        setState(() {
          msg = 'Please supply a valid email';
          showSnackBar(context,msg);
        });
      }
      else Navigator.pop(context);
    }
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
        user.birthday =
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
      // MemberDatabaseService()
      //     .uploadProfileImage(context, _pickedImage!)
      //     .then((value) => {m.imageURL = value, showToast('photo uploaded')});
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
}
