import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iddb/shared/loading.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Future<void> initState() async {
    setupFirebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Loading();
  }
  Future<void> setupFirebase() async {
    final FirebaseApp app = await Firebase.initializeApp();
  }
}
