import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iddb/screens/authenticate/register.dart';
import 'package:iddb/screens/home_manager/add_class.dart';
import 'package:iddb/screens/home_servant/add_member.dart';
import 'package:iddb/screens/member_details/member_view.dart';
import 'package:iddb/screens/wrapper.dart';
import 'package:iddb/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/class/class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(app: app),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.app}) : super(key: key);
  final FirebaseApp app;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().my_user,
      initialData: MyUser(login_id: ''),
      catchError: (_, __) =>  MyUser(login_id: ''),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/wrapper',
        routes: {
          '/wrapper': (context) => const Wrapper(),
          '/register': (context) => const Register(),
          '/class' : (context) => const ClassView(),
          '/add_member' : (context) => const AddMember(),
          '/add_class' : (context) => const AddClass(),
          '/member_details' : (context) => MemberView(),
        },
      ),
    );

    // return FutureBuilder(
    //   // Initialize FlutterFire:
    //   future: _initialization,
    //   builder: (context, snapshot) {
    //     // Check for errors
    //     if (snapshot.hasError) {
    //       return MaterialApp();
    //     }
    //
    //     // Once complete, show your application
    //     if (snapshot.connectionState == ConnectionState.done) {
    //
    //       try {
    //         return StreamProvider<MyUser>.value(
    //                     value: AuthService().my_user,
    //                     initialData: new MyUser(uid: ''),
    //                     child: MaterialApp(
    //                       initialRoute: '/wrapper',
    //                       routes: {
    //                         '/wrapper': (context) => Wrapper(),
    //                         '/register': (context) => Register(),
    //                       },
    //                     ),
    //                   );
    //       } catch (e) {
    //         print(e);
    //       }
    //
    //     }
    //
    //     // Otherwise, show something whilst waiting for initialization to complete
    //     return MaterialApp();
    //   },
    // );
  }
}
