import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_demo/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'auth.dart';
import 'login_page.dart';
import 'api/firebase_api.dart';
import 'package:path/path.dart';
import 'show_img_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  HomePage({required this.auth, required this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File?>file=[];
  List<File?>listPath=[];
  void _signOut() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
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
            child: Center(
                child: Column(
                  children: [
                    RaisedButton(
                        onPressed: SelectFile,
                        child: new Text('Select File', style: new TextStyle(fontSize: 30))
                    ),
                    /*
                    Text(
                      fileName,
                      style: TextStyle(fontSize: 16),
                    ),*/
                    RaisedButton(
                        onPressed: UploadFile,
                        child: new Text('Upload File',style:new TextStyle(fontSize: 30))
                    ),
                    RaisedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>ShowImgPage(auth: widget.auth,)),
                          );
                        },
                        child: new Text('See Files',style:new TextStyle(fontSize: 30))
                    )
                  ],
                )
            )
        )
    );
  }

  Future SelectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    final path = result.files.single.path!;
    listPath.add(File(path));
    setState(() => file=listPath);
  }

  Future UploadFile() async{
    if(file.isEmpty) return;
    String userId = await widget.auth.currentUser();
    for(var i=0;i<listPath.length;i++){
      final destination = '$userId/Uploads/$i';
      FirebaseApi.uploadFile(userId,'Uploads', listPath[i]!);
      final fileName=basename(listPath[i]!.path);
      print('ready to upload file : $fileName');
    }
    listPath.clear();
    file.clear();
  }


}
