
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';



class FirebaseApi{

  static uploadFile(String userId, String typeUpload, File file) async{
    ListResult result = await FirebaseStorage.instance.ref('$userId/$typeUpload').listAll();
    int filesCount = result.items.length;
    int fileIndex = filesCount+1;
    String nameNewFile = 'IMG_'+'$fileIndex';
    try {
      final ref = FirebaseStorage.instance.ref('$userId/$typeUpload/$nameNewFile');
      await ref.putFile(file);
      uploadInfoDatabase(userId, typeUpload, nameNewFile, fileIndex);
    } on FirebaseException catch (e) {
      print('error while uploading : $e');
    }
  }

  static Future<void> uploadInfoDatabase(String userId, String typeUpload, String nameNewFile, int fileIndex) async{
    String downloadURL = await FirebaseStorage.instance.ref('$userId/$typeUpload/IMG_'+'$fileIndex').getDownloadURL() ;
    DocumentReference users = FirebaseFirestore.instance.collection(userId).doc(typeUpload);
    var doc = await users.get();
    if(!doc.exists){
      users
          .set({
        'number of files' : fileIndex,
        'url_'+'$nameNewFile' : downloadURL
      })
          .then((value) => print('User Added'))
          .catchError((error) => print('Updload Failed'));
    }else{
      users
          .update({
        'number of files' : fileIndex,
        'url_'+'$nameNewFile' : downloadURL
      })
          .then((value) => print('User Added'))
          .catchError((error) => print('Updload Failed'));
    }
  }

  static Future<List<FirebaseFile>>listAll(String userId, String typeDoc) async{
    var users = await FirebaseFirestore.instance.collection(userId)
        .doc(typeDoc)
        .get();
    Map<String, dynamic>? data = users.data() as Map<String, dynamic>?;
    int numberURL = data?['number of files'];
    List<FirebaseFile>futureFile = [];
    for (var i = 1; i <= numberURL; i++) {
      String takeKeyIMG = 'url_IMG_' + '$i';
      String nameIMG = 'IMG_' + '$i';
      FirebaseFile file = new FirebaseFile(
          name: nameIMG, url: data?[takeKeyIMG]);
      futureFile.add(file);
    }
    for (var i = 1; i <= numberURL; i++) {
      String testURL = futureFile[i - 1].url;
    }
    return futureFile;
  }

  static Future downloadFile(String ref) async{
    print("Prepare to download");
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref}');
  }
}


