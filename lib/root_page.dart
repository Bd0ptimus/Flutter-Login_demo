import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_demo/home_page.dart';
import 'auth.dart';
import 'login_page.dart';

class RootPage extends StatefulWidget {
  RootPage({required this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        authStatus=userId==null?AuthStatus.notSignedIn:AuthStatus.signedIn;
      });
    });
  }

  void _singedIn(){
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus){
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _singedIn,
        );
      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignedOut: _signedOut,
        );
    }
  }
}
