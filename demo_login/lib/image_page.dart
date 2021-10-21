import 'package:flutter/material.dart';
import 'package:login_demo/api/firebase_api.dart';
import 'package:login_demo/api/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key?key,
    required this.file,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async{
                await FirebaseApi.downloadFile(file.name);
                final snackBar = SnackBar(
                  content: Text('Downloaded ${file.name}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.file_download)
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Image.network(
        file.url,
        height:double.infinity,
        width: double.infinity,
        fit: BoxFit.cover
      )
    );
  }
}
