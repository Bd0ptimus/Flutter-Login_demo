import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

final site ="https://2616-93-188-41-67.ngrok.io/";
final manageLogin = "$site/authentication_account/manage_login.php";
final manageRegister = "$site/authentication_account/manage_register.php";

Future<String> readID()async{
  print('start read file Id');
  String text="";
  try {
    print('In read Id');
    final Directory dir = await getApplicationDocumentsDirectory();
    print('Before open file');
    final File file = File ('${dir.path}/userid.txt');
    print('Before read to string');
    text = await file.readAsString();
    print('text : $text');
  }catch(e){
    print('can not read file id');
  }
  return text;
}

Future<String> readCookie() async{
  print('start read file cookie');
  String text="";
  try {
    print('In read Cookie');
    final Directory dir = await getApplicationDocumentsDirectory();
    print('Before open file');
    final File file = File ('${dir.path}/cookie.txt');
    print('Before read to string');
    text = await file.readAsString();
    print('text : $text');
  }catch(e){
    print('can not read file cookie');
  }
  print('text : $text');
  return text;
}

Future writeID(String inWrite)async{
  final Directory dir = await getApplicationDocumentsDirectory();
  final File file = File('${dir.path}/userid.txt');
  await file.writeAsString(inWrite);
}

Future writeCookie(String inWrite)async{
  final Directory dir = await getApplicationDocumentsDirectory();
  final File file = File('${dir.path}/cookie.txt');
  await file.writeAsString(inWrite);
}