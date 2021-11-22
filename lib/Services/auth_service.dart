import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:lcn/Providers/dio_provider.dart';

class AuthService {

  AuthService(this.ref);

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Authentification1.asmx";

  Future login(String username, String password) async {
    List<Cookie> cookies = [];
    var cookieJar = CookieJar();
    String serviceMethod = "Login";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+'/'+serviceMethod,
        data: {'username': username, 'password': password, 'createPersistentCookie': 'false',},
        options: Options(headers: {'Content-Type': 'application/json'})
    );
    print(res.statusCode);
    print('------------------------------------------');
    print({res.headers.map.values.toList()[2]});
    print({res.data});
    var session_list = res.headers.map.values.toList()[2];
    print('------------------------------------------');
    print(session_list[0].runtimeType);
    print('------------------------------------------');
    print('list length');
    print(session_list.length);
    if (session_list.length == 2) {
      var first_session_list = session_list[0].split(RegExp(r"\;"));
      var second_session_list = session_list[1].split(RegExp(r"\;"));
      cookies = [Cookie('sessionId', '${first_session_list[0]}'), Cookie('gvsToken', '${second_session_list[0]}')];
      await cookieJar.saveFromResponse(Uri.parse(basicUrl+serviceMethod), cookies);
      _dio.interceptors.add(dioCookieManager.CookieManager(cookieJar));
    }


    return res;
  }


  Future<Response> logout() async {
    String serviceMethod = "Logout";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+'/'+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json'})
    );
    return res;
  }


  Future<Response> getUserCustomData() async {
    String serviceMethod = "SetUserCustomData";
    print('${basicUrl+'/'+serviceMethod}');
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.get(
        basicUrl+'?op='+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json'})
    );
    print('-----------------------usersdata');
    var document = parse(res.data);
    print(document.body!.getElementsByTagName('content'));
    return res;
  }
}