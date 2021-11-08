import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iddb/models/user.dart';
import 'package:iddb/services/database/users_database.dart';
import 'package:iddb/shared/messages.dart';

class AuthService {
  final FirebaseAuth _firebase_auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  MyUser _userFromFirebaseUser(User? user) {
    MyUser my_user = MyUser(login_id: '');
    if (user != null) {
      {
        return MyUser(login_id: user.uid);
      }
    } else {
      print('user==null');
      return new MyUser(login_id: '');
    }
    ;
  }

  // auth change user stream
  Stream<MyUser> get my_user {
    print("Fired");
    MyUser my_user = MyUser(login_id: '');
    try {
      return _firebase_auth
          .authStateChanges()
          // .map((User user) => {});
          // .listen(_userFromFirebaseUser);
          .map(_userFromFirebaseUser);
      // .listen((event) { })
// .asyncExpand(_get_db_user);
    } catch (e) {
      print("error is :-" + e.toString());
      return Stream.empty();
    }
    // .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _firebase_auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return MyUser(login_id: '');
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebase_auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // if (!user!.emailVerified) {
      //   await user.sendEmailVerification();
      //   showToast('We have sent you a verifying email');
      // }

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return MyUser(login_id: '');
    }
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebase_auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      // MyUser myUser = await _get_db_user(user!.uid);
      // if (!user!.emailVerified) {
      // await user.sendEmailVerification();
      // showToast('We have sent you a verifying email');
      // }
// my_user.listen((User user) { })
      _userFromFirebaseUser(user!);
    } catch (error) {
      print(error.toString());
      return MyUser(login_id: '');
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _firebase_auth.signOut();
    } catch (error) {
      print("error signout" + error.toString());
    }
    return MyUser(login_id: '');
  }

  Future<User?> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _firebase_auth.signInWithCredential(credential);
    return _firebase_auth.currentUser;
  }

  Future<User?> _signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await _facebookAuth.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    _firebase_auth.signInWithCredential(facebookAuthCredential);
    return _firebase_auth.currentUser;
  }

  Future<MyUser> loginWithFacebook() async {
    try {
      Future<User?> result = _signInWithFacebook();
      return result.then((value) => _userFromFirebaseUser(value!));
    } catch (error) {
      print(error.toString());
      return MyUser(login_id: '');
    }
  }

  Future<MyUser> loginWithGmail() async {
    try {
      Future<User?> result = _signInWithGoogle();
      return result.then((value) => _userFromFirebaseUser(value!));
    } catch (error) {
      print("error gmail" + error.toString());
      return MyUser(login_id: '');
    }
  }

  Future<MyUser> _get_db_user(User fb_user) async {
    MyUser user = MyUser(login_id: '');

    await FirebaseDatabase()
        .reference()
        .child('users')
        .orderByChild('login_id')
        .equalTo(fb_user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, v) => {
            user.id = key,
            user.login_id = v['login_id'],
            user.password = v['password'],
            user.email = v['email'],
            user.type = v['type'],
            user.class_id = v['class_id'],
            user.phone = v['phone'],
            user.photoUrl = v['photoUrl'],
            user.birthday = v['birthday'],
          });
    });
    return user;
  }
}
