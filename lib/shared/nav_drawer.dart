import 'package:flutter/material.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:provider/provider.dart';
class NavDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
               // CircleAvatar(backgroundImage: NetworkImage(user.photoUrl!),),
                Text(
                  'Deacons',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://scontent.fcai1-2.fna.fbcdn.net/v/t31.18172-8/12779085_10153439604893951_2889210514726304878_o.jpg?_nc_cat=109&ccb=1-5&_nc_sid=973b4a&_nc_ohc=iAJzKRJlAMoAX--v7YO&_nc_ht=scontent.fcai1-2.fna&oh=4898cefc8e5a3537aaddd54481274b9b&oe=618B8578'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async => {
            await _auth.signOut()
            },
          ),
        ],
      ),
    );
  }
}
