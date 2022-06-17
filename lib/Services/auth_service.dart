//import 'dart:html';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html;
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Providers/state_provider.dart';
import 'package:lcn/State_Services/tableau_state_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';

class AuthService {
  AuthService(this.ref);

  final Ref ref;
  //final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Authentification1.asmx";
  /// domain besteht nachher aus der eingetragenen ip des Nutzer
  /// ToDo: Provider für die IP
  final String domain = "http://access.lcn.de/lcngvsdemo/webservices";
  //final String basicUrl = "http://192.168.0.190/LCNGVS/WebServices/Authentification1.asmx";


  Future<CustomData> login(String username, String password) async {
    Options options = Options(
      headers: {},
    );
    List<Cookie> cookies = [];
    var cookieJar = CookieJar();
    String serviceMethod = "Login";
    Dio _dio = ref.watch(dioProvider);
    print('Dio Response');
    Response res = await _dio.post(domain + '/Authentification1.asmx/' + serviceMethod,
        data: {
          'username': username,
          'password': password,
          'createPersistentCookie': 'true',
        },
        options: options);

    if (res.statusCode == 200 && res.data['d']['IsSuccess'] == true) {
      String sessionId = res.headers.map['set-cookie']![0];
      String token = res.headers.map['set-cookie']![1];
      List tmp_sessionId = sessionId.split(RegExp(r"\;"));
      List tmp_token = token.split(RegExp(r"\;"));
      sessionId = tmp_sessionId[0];
      List tmp_session = sessionId.split(RegExp(r"\="));
      sessionId = tmp_session[1];
      token = tmp_token[0];
      List tmp_toke = token.split(RegExp(r"\="));
      token = tmp_toke[1];
      cookies = [
        Cookie('ASP.NET_SessionId', '$sessionId'),
        Cookie('LCN-GVS-Auth', '$token')
      ];
      cookieJar.saveFromResponse(
          Uri.parse(domain), cookies).then((value) {
            _dio.interceptors.add(dioCookieManager.CookieManager(cookieJar));
      }
      );

      /// Copy CustomData in Model
      CustomData customData = CustomData.fromMap(res.data['d']['CustomData']);
      return customData;
    } else {
      throw(Exception('CustomData no found'));
    }
  }

  Future<Response> logout() async {
    String serviceMethod = "Logout";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(domain + '/Authentification1.asmx' + serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json'}));
    return res;
  }

  Future<Response> getUserCustomData(
      {required Map customData, required String currentUri}) async {
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
    XmlNode buildParagraphXML(
        {required String type,
        required String attribute,
        required String value}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
        builder.attribute('name', attribute);
        builder.text(value);
      });
      return builder.buildFragment();
    }

    print(customData['Strings']);
    lastTableauUri.add(buildParagraphXML(
        type: 'String', attribute: 'LastTableauUri', value: currentUri));
    recentTableauUri.add(buildParagraphXML(
        type: 'String', attribute: 'RecentTableauUri', value: currentUri));
    hiveList.add({'Name': 'RecentTableauUri', 'Value': currentUri});
    customDataStrings.forEach((element) {
      if (element['Name'] == 'RecentTableauUri' &&
          element['Value'] != currentUri) {
        recentTableauUri.add(buildParagraphXML(
            type: 'String',
            attribute: 'RecentTableauUri',
            value: element['Value']));
        hiveList.add(element);
      }
    });
    hiveList.add({'Name': 'LastTableauUri', 'Value': currentUri});
    print(recentTableauUri);
    //box.put('currentUserData', hiveList);
    customUserData = recentTableauUri + lastTableauUri;

    var value = RegExp(r"Musterhaus\Schnelltableau");
    var jhf = buildParagraphXML(
        type: 'String', attribute: 'LastTableauUri', value: value.pattern);
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

    Response res = await _dio.post(domain,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': "http://www.lcn.de/LCNGVS/SetUserCustomData"
          },
        ),
        data: document1);
    ref.read(customTableauListProvider.state).update((state) => hiveList);

    print('-----------------------usersdata');
    var document = html.parse(res.data);
    print(res);
    //print(document.body!.getElementsByTagName('content'));
    return res;
  }
}
