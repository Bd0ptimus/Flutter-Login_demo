import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_demo/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'auth.dart';
import 'login_page.dart';
import 'api/firebase_api.dart';
import 'package:path/path.dart';
import 'show_img_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'security/encrypt_decrypt.dart';
import 'package:http/http.dart' as http;
import 'package:base32/base32.dart';


final site = "https://49c8-93-188-41-67.ngrok.io/"; // Paste Your API Here
final api = "$site/manage_img.php";
final profile = "$site/userdatadisplay.php";


class HomePage extends StatefulWidget {
  HomePage({required this.auth, required this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File?>file=[];
  List<String>listImg=[];
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
    XFile? fileTest;
    final ImagePicker _pick = ImagePicker();
    fileTest = await _pick.pickImage(source: ImageSource.gallery);
    var test = await fileTest?.readAsBytes();

    String img64=base64Encode(List<int>.from(test!)); // Convert Uint8List to List<int>
    print ("img64 : $img64");
    /*
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    final path = result.files.single.path!;*/
    listImg.add(img64);
    //setState(() => file=listPath);
  }

  Future UploadFile() async{
    if(listImg.isEmpty) return;
    //String userId = await widget.auth.currentUser();
    final lengthListImg = listImg.length;
    print ("list IMG Length : $lengthListImg");
    for(var i=0;i<listImg.length;i++){
      /*
      final destination = '$userId/Uploads/$i';
      FirebaseApi.uploadFile(userId,'Uploads', listImg[i]!);
      final fileName=basename(listPath[i]!.path);
      print('ready to upload file : $fileName');*/

      try{
        print ("before post");
        final response = await http.post(Uri.parse("https://49c8-93-188-41-67.ngrok.io/manage_img.php"), body: {
          'img': Security(text: listImg[i]).encrypt(),
          //"img": listImg[i],
        });
        print ("After post");
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          print('result : $result');
          //return result;
        } else {
          var testresponse = response.statusCode;
          //return 'Server Error : $testresponse ';
        }

      }catch(e){
        print('App Error : $e');
        //return 'App Error : $e';
      }

    }
    print("Before clear List");
    listImg.clear();
    print("After clear List");
    //file.clear();
  }

  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/counter.txt');
  }


}
