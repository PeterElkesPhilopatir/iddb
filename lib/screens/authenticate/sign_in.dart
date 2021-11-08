import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:iddb/shared/button_styles.dart';
import 'package:iddb/shared/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 20.0,
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final AuthService _auth = AuthService();
  String email = '', password = '', msg = '';
  // bool loading = false;

  @override
  Widget build(BuildContext context) {
    return
      // loading
      //   ? Loading() :
        Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          child: Text(
                            'Login',
                          ),
                          onPressed: () {
                            setState(() {
                              // loading = true;
                            });
                            onLoginPressed();
                          },
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red))))),
                      SizedBox(width: 20.0),
                      TextButton(
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          style: getBordered(),),
                    ],
                  ),
                  SizedBox(height: 40.0,),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {onGooglePressed();},
                  ),
                  SizedBox(height: 20.0,),

                  // SignInButton(
                  //   Buttons.Facebook,
                  //   onPressed: () {onFacebookPressed();},
                  // ),
                ],
              ),
            ));
  }

  Future<void> onLoginPressed() async {
    MyUser result = await _auth.loginWithEmailAndPassword(email, password);
    if (result.login_id == '') {
      setState(() {
        // loading = false;
        msg = 'Try Again';
        final snackBar = SnackBar(content: Text(msg));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

  }
  Future<void> onGooglePressed() async {
    MyUser result = await _auth.loginWithGmail();
    if (result.login_id == '') {
      setState(() {
        // loading = false;
        msg = 'Try Again';
        final snackBar = SnackBar(content: Text(msg));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
    else print(result.email);
  }
  Future<void> onFacebookPressed() async {
    MyUser result = await _auth.loginWithFacebook();
    if (result.login_id == '') {
      setState(() {
        // loading = false;
        msg = 'Try Again';
        final snackBar = SnackBar(content: Text(msg));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}
