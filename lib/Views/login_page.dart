import 'dart:collection';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Services/tableau_service.dart';
//import 'package:http/http.dart';
import 'package:lcn/Views/home_page.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart' as xml2json;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:cookie_jar/cookie_jar.dart';



class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  //final Uri url = Uri.parse("http://access.lcn.de/LCNGVSDemo/WebServices/Authentification1.asmx/Login");
  final String url = "http://access.lcn.de/LCNGVSDemo/WebServices/Authentification1.asmx/Login";

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late Dio _dio;


  String basicAuthenticationHeader(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }



  Future _getAuthStatus() async {
    /*
    //Response res = await post(url, body: {'username': _usernameController.text, 'password': _passwordController.text, 'createPersistentCookie': 'false', 'Content-Type': 'x-www-form-urlencoded'}, );
    List<Cookie> cookies = [];
    var cookieJar = CookieJar();

    //cookies = await cookieJar.loadForRequest(Uri.parse("http://access.lcn.de/LCNGVSDemo/Authentification1.asmx/Login?username=gast&password=lcn&createPersistentCookie=false"));
    Response res = await _dio.post(
        url,
        data: {'username': _usernameController.text, 'password': _passwordController.text, 'createPersistentCookie': 'false',},
        options: Options(headers: {'Content-Type': 'application/json'}));

    //print(cookies);
    //print({res.headers.value('set-cookie')});
    //cookieJar.
    print('------------------------------------------');
    print({res.headers.map.values.toList()[1]});
    var session_list = res.headers.map.values.toList()[1];
    print('------------------------------------------');
    print(session_list[0].runtimeType);
    print('------------------------------------------');
    var first_session_list = session_list[0].split(RegExp(r"\;"));
    var second_session_list = session_list[1].split(RegExp(r"\;"));
    cookies = [Cookie('sessionId', '${first_session_list[0]}'), Cookie('gvsToken', '${second_session_list[0]}')];
    await cookieJar.saveFromResponse(Uri.parse(url), cookies);
    _dio.interceptors.add(dioCookieManager.CookieManager(cookieJar));
    //print(dioCookieManager.CookieManager.getCookies(cookies));
    //print(first_session_list);

    print('------------------------------------------');
    Map jas = res.data;
    List elements = [];
    List items = [];
    */
    List _tableauNames = [];
    Map _customData = new Map();
    final logind = ref.read(dioAuthProvider);

    Response bla = await logind.login(_usernameController.text, _passwordController.text);
    print(bla.headers.map.values.toList()[1].length);
    if (bla.statusCode == 200 && bla.headers.map.values.toList()[1].length == 2) {
      final futureGetTableaus = ref.read(dioTableauProvider);
      List bla2 = await futureGetTableaus.getTableaus();
      print('----------------------');
      print('');
      print('${bla.data['d']['CustomData']}');
      print('----------------------');
      print('login Data');
      print('${bla.data['d']['CustomData']['Strings']}');
      _tableauNames = bla.data['d']['CustomData']['Strings'];
      _customData = bla.data['d']['CustomData'];
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(tableauNames: _tableauNames, customData: _customData,))
      );
      //print('tableaus response');
      //print(bla2.data);

     //print(res1.data);
      /*
      //print(HashMap.from(jas.values.first));
      var zuvt = HashMap.from(jas.values.first);
      print(zuvt["CustomData"]["Strings"][0]);
      var document = XmlDocument.parse(res.data);
      print(res.data.runtimeType);
      var id = document.findAllElements('UniqueServerId').first.innerXml;
      var customData = document.findAllElements('CustomData').first.innerXml;
      var customDataElement = document.findAllElements('Strings').first.children;
      customDataElement.forEach((p0) {
        if (p0.innerXml.isNotEmpty) {
          elements.add(p0);
          //print(elements);
        } else {
          print('false');
        }

      });
      var customDataItem = customDataElement;
      print('UniqueServerId: $id');
      //print('CustomData: ${customDataItem}');
      
      var xmlTableauValue = elements[0].innerXml.split(RegExp(r"\\"));
      print('TableauValue: ${xmlTableauValue[1]}');
      elements.forEach((element) {
        var temp = element.innerXml.split(RegExp(r"\\"));
        items.add(temp[1]);
        print(items);
      });
      //print(elements);
      if (id.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(tableauNames: items,))
        );
      } else {
        print('access denied');
      }
      */
    } else {
      print('Dont Work');
    }

  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _dio = Dio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                  Icons.public_outlined,
                  color: Colors.white,
              ),
              label: const Text(
                'LCN-GVS-Adresse ändern',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0
                ),
              ))
        ],
        title: const Text(
          '             Login GVS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height*0.2,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white
                      )
                  ),
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Column(
                    children: [
                      _loginFields(context, _usernameController, 'Benutzername'),
                      _loginFields(context, _passwordController, 'Passwort')
                    ],
                  ),
                ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height*0.05,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child:  _loginButton(context)
            ),
          )
        ],

      ),
    );
  }



  Widget _loginFields(BuildContext context, TextEditingController controller, String fieldIdentifier) {
    return Row(
      children: [
        Container(
          width: 100.0,
          child: Text(
            fieldIdentifier,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0
            ),
          ),
        ),
        Container(
          width: 150.0,
          child: TextField(
            style: const TextStyle(
              color: Colors.white
            ),
            controller: controller,
          )
        )
      ],
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width*0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: TextButton(
        onPressed: () {_getAuthStatus();},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.grey
          ),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ))
        ),
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0
            ),
          ),
        ),
      ),
    );
  }



}
