import 'package:flutter/material.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/screens/authenticate/sign_in.dart';
import 'package:iddb/screens/home_manager/HomeManager.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'authenticate/authenticate.dart';
import 'authenticate/register.dart';
import 'home_servant/HomeServant.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    MyUser user = Provider.of<MyUser>(context);
    // return either the Home or Authenticate widget
    if (user.login_id == '') {
      return const Authenticate();
    } else {
      // if (!user.verified) {
      //   return SignIn();
      // }
      // else {
      if (user.type == UserType.SERVANT)
        return HomeServant();
      else if (user.type == UserType.MANAGER)
        return HomeManager();
      else {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        MyUser myUser = new MyUser(login_id: 'admin');
                        myUser.type = UserType.MANAGER;
                        myUser.email = 'admin@admin.com';
                        myUser.password = 'admin1';
                        myUser.add();
                      },
                      child: Text(user.type!)),
                  RaisedButton(
                    onPressed: () async {await _auth.signOut();},
                    child: Text('logout'),
                  )
                ],
              ),
            ),
          ),
        );
      }
      // }
    }
  }
}
