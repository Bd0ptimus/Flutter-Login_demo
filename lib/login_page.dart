
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';


enum FormType{
  login,
  register
}

class LoginPage extends StatefulWidget {
  LoginPage ({required this.auth, required this. onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  String _email ="";
  String _password="";
  FormType _formType=FormType.login;
  final formKey = new GlobalKey<FormState>();

  bool ValidateAndSave(){
    final form = formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void ValidateAndSubmit() async{
    if(ValidateAndSave()) {
      try{
        if (_formType==FormType.login){
          String userId = await widget.auth.signInWithEmailAndPassword( _email, _password);
          print('signed in: $userId');
        }else{
          String userId = await widget.auth.createUserWithEmailAndPassword(_email,_password);
          print('register user: $userId');
        }
        widget.onSignedIn();
      }catch(e){
        print('Error: $e');
      }
    }
  }

  void MoveToRegister() {
    formKey.currentState?.reset();
    setState((){
      _formType=FormType.register;
    });
  }

  void MoveToLogin(){
    formKey.currentState?.reset();
    setState((){
      _formType=FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:new AppBar(
        title: new Text('Login Demo'),
      ),
      body: new Container(
        padding:EdgeInsets.all(20),
        child:new Form(
          key : formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs()+buildSubmitButton(),
            )
        )
      )
    );
  }

  List<Widget>buildInputs(){
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator:(value){
          if (value!.isEmpty)
          {
            return 'Email cant be empty!';
          }
          else{
            return null;
          }
        },
        onSaved: (value) => _email = value!,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator:(value){
          if (value!.isEmpty)
          {
            return 'Password cant be empty!';
          }
          else{
            return null;
          }
        },
        onSaved: (value) => _password = value!,
      ),
    ];
  }

  List<Widget>buildSubmitButton() {
    if(_formType==FormType.login) {
      return[
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20)),
          onPressed: ValidateAndSubmit,
        ),
        new FlatButton(
          onPressed: MoveToRegister,
          child: new Text('Create an account', style: new TextStyle(fontSize:20)),
        )
      ];
    }else{
      return[
        new RaisedButton(
          child: new Text('Create an account', style: new TextStyle(fontSize: 20)),
          onPressed: ValidateAndSubmit,
        ),
        new FlatButton(
          onPressed: MoveToLogin,
          child: new Text('Have an account? Login', style: new TextStyle(fontSize:20)),
        )
      ];
    }

  }
}
