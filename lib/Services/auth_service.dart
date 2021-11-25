//import 'dart:html';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html;
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Providers/state_provider.dart';
import 'package:lcn/State_Services/tableau_state_service.dart';
import 'package:xml/xml.dart';

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
    print({res.headers.map.values.toList()[1]});
    print({res.data});
    var session_list = res.headers.map.values.toList()[1];
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


  Future<Response> getUserCustomData({required Map customData,required String currentUri}) async {
    /// liegt nur als SOAP 1.1 und 1.2 ACTION vor
    //String serviceMethod = "SetUserCustomData";
    //print('${basicUrl+'/'+serviceMethod}');
    print(customData);
    print(currentUri);
    List quickTableauUri = [];
    List recentTableauUri = [];
    List lastTableauUri = [];
    List customDataStrings = customData['Strings'];
    late List customUserData;
    List hiveList = [];
    //var box = await Hive.openBox('currentUserDataBox');




    final body = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
    <SetUserCustomData xmlns="http://www.lcn.de/LCNGVS/">
    <customData fetchFromParent="false">
    <Strings>
    </Strings>
    <Integers>
    </Integers>
    <Booleans>
    </Booleans>
    </customData>
    </SetUserCustomData>
    </soap:Body>
    </soap:Envelope>
    ''';
    XmlNode buildParagraphXML({required String type,required String attribute,required String value}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
        builder.attribute('name', attribute);
        builder.text(value);
      });
      return builder.buildFragment();
    }
    print(customData['Strings']);
    lastTableauUri.add(buildParagraphXML(type: 'String', attribute: 'LastTableauUri', value: currentUri));
    recentTableauUri.add(buildParagraphXML(type: 'String', attribute: 'RecentTableauUri', value: currentUri));
    hiveList.add({'Name': 'RecentTableauUri', 'Value': currentUri});
    customDataStrings.forEach((element) {
      if (element['Name'] == 'RecentTableauUri' && element['Value'] != currentUri) {
        recentTableauUri.add(buildParagraphXML(type: 'String', attribute: 'RecentTableauUri', value: element['Value']));
        hiveList.add(element);
      }
    });
    hiveList.add({'Name': 'LastTableauUri', 'Value': currentUri});
    print(recentTableauUri);
    //box.put('currentUserData', hiveList);
    customUserData = recentTableauUri + lastTableauUri;

    var value = RegExp(r"Musterhaus\Schnelltableau");
    var jhf = buildParagraphXML(type: 'String', attribute: 'LastTableauUri', value: value.pattern);
    print(jhf);
    print(jhf.nodeType);
    final document1 = XmlDocument.parse(body);
    //document1.children.add(jhf);
    var te = document1.findAllElements('Strings');
    customUserData.forEach((element) {
      te.first.children.add(element);
    });

    print('Hive-------------------Hive');
    //print(box.get('currentUserData'));

    print('doc----------------doc');
    print(document1);
    Dio _dio = ref.watch(dioProvider);

    Response res = await _dio.post(
        basicUrl,
        options: Options(
          headers: {'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': "http://www.lcn.de/LCNGVS/SetUserCustomData"
          },
        ),
        data: document1
    );
    ref.read(customTableauListProvider.state).update((state) => hiveList);

    print('-----------------------usersdata');
    var document = html.parse(res.data);
    print(res);
    //print(document.body!.getElementsByTagName('content'));
    return res;
  }
}