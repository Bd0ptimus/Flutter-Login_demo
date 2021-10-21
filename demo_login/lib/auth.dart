import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_demo/config.dart';
import 'library.dart';

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  //Future<String>currentUser();
  Future<String>currentUser() ;
  Future<void>signOut();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String email, String password) async{
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.user!.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async{
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.user!.uid;
  }

  /*
  Future<String>currentUser() async{
    //User user = await _firebaseAuth.currentUser!;
    //return user.uid;
    UserManage user;
    return user.UserOut();

  }*/

  Future<String>currentUser() async{
    return await readID();
  }

  Future<void>signOut() async{
    await _firebaseAuth.signOut();
  }
}

