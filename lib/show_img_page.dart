import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_demo/api/firebase_file.dart';

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

  late Future<List<FirebaseFile>>futureFiles;
  @override
  void initState(){
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('User Id : $userId');
    futureFiles=FirebaseApi.listAll('$userId/Uploads');
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
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot){
            switch (snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              default:
                if(snapshot.hasError){
                  return Center(child: Text('Some error occured!'));
                }else{
                  final files = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height:12),
                      Expanded(
                          child: ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context,index){
                                final file = files[index];
                                return buildFile(context, file);
                            },
                          )
                      )
                    ],
                  );
                }
            }
          }
        )
    );
  }
}
