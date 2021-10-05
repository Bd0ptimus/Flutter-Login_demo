
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_demo/auth.dart';

class HomePage extends StatelessWidget{
  HomePage({required this.auth, required this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut();
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title:  new Text('Wellcome'),
        actions:<Widget> [
          new FlatButton(
              onPressed: _signOut,
              child: new Text('Log out', style: new TextStyle(color: Colors.white)))
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text('Welcome', style: new TextStyle(fontSize: 32))
        ),
      )
    );
  }
}