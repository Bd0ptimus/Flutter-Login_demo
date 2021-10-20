import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login_demo/security/encrypt_decrypt.dart';
import 'package:login_demo/config.dart';

class DatabaseRequest{
  late final String email;
  late final String password;
  DatabaseRequest({ required this.email, required this.password});
  Future<String> requestCreate() async{
    print('In request Create');
    String url=manageRegister;
    print('URL : $url');
    return request(url);
  }

  Future<String> requestSignin()async{
    String url=manageLogin;
    return request(url);
  }

  Future<String>request(String url)async{
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': Security(text: email).encrypt(),
        'password': Security(text: password).encrypt(),
        'cookie' : await readCookie()
      });
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('result : $result');
        return result;
      } else {
        var testresponse = response.statusCode;
        return '132';
      }
    } catch (e) {
      print('App Error : $e');
      return '131';
    }
  }

}
