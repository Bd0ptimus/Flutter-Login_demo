import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile{
  late final String name;
  late final String url;
  FirebaseFile({
    required this.name,
    required this.url,
  });
  String outName(){
    return this.name;
  }

  String outURL(){
    return this.url;
  }
}