import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_demo/api/firebase_file.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'api/firebase_api.dart';
import 'home_page.dart';
import 'auth.dart';
import 'image_page.dart';

class ShowImgPage extends StatefulWidget {
  ShowImgPage({required this.auth});
  final BaseAuth auth;

  @override
  _ShowImgPageState createState() => _ShowImgPageState();
}

class _ShowImgPageState extends State<ShowImgPage> {
  List<dynamic>? categoryList;
  Future getDatas()async{
    try{
      final response = await http.get(Uri.parse("https://49c8-93-188-41-67.ngrok.io/return_img.php"));
      print("prepare to convert :");
      if(response.statusCode == 200){
        setState((){
          categoryList = json.decode(response.body);
          print("category list : $categoryList");
        });
      }
    }catch(e){
      print('App error: $e');
    }

  }

  showImage(String image){
    return Image.memory(base64Decode(image), width: 200, height: 100,);
  }

  //late Stream<List<FirebaseFile>>futureFiles;
  @override
  void initState(){
    super.initState();
    /*
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('User Id : $userId');
    futureFiles=Stream.fromFuture(FirebaseApi.listAll(userId! , 'Uploads') );*/
    print('load 1 ');
    getDatas();
  }

  Widget buildFile(BuildContext context , FirebaseFile file)=> ListTile(
    leading: Image.network(
      file.url,
      width:52,
      height:52,
      fit: BoxFit.cover,
    ),
    title: Text(
      file.name,
      style :TextStyle(
        fontWeight: FontWeight.bold
      ),
    ),
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>ImagePage(file:file),
      ));
    },
  );

  Widget buildHeader(int length) => ListTile(
    tileColor: Colors.blue,
    leading: Container(
      width: 52,
      height: 52,
      child: Icon(
        Icons.file_copy,
        color: Colors.white,
      ),
    ),
    title: Text(
      '$length Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title:  new Text('All files in your DB'),
          actions:<Widget> [
            new FlatButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>HomePage(auth: widget.auth, onSignedOut: () {  },)),
                  );
                },
                child: new Text('Back', style: new TextStyle(color: Colors.white)))
          ],
        ),
        body: ListView.builder(
          itemCount: categoryList?.length,
          itemBuilder: (context,index){
            return ListTile(
              trailing: categoryList!=null ? showImage(categoryList![index]['img']) : null,
              //trailing: showImage(categoryList![index]['img']),
            );
          },
        )
    );
  }
}
