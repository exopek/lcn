import 'dart:collection';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Providers/state_provider.dart';
import 'package:lcn/Services/tableau_service.dart';
//import 'package:http/http.dart';
import 'package:lcn/Views/home_page.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart' as xml2json;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:cookie_jar/cookie_jar.dart';

import '../Models/models.dart';



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

    final auth = ref.read(dioAuthProvider);
    final customTableauProvider = ref.read(customTableauListProvider.state);

    try {
      CustomData _customData = await auth.login(_usernameController.text, _passwordController.text);
      customTableauProvider.update((state) => _customData.tableaus);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );
    } catch(e) {
      throw(Exception(e));
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
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage(
                      'assets/login.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 220.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _loginFields(context, _usernameController, 'Benutzername'),
                              _loginFields(context, _passwordController, 'Passwort')
                            ],
                          ),
                        ),
                        _loginButton(context)
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),


        ],

      ),
    );
  }



  Widget _loginFields(BuildContext context, TextEditingController controller, String fieldIdentifier) {
    return Container(
      height: MediaQuery.of(context).size.height/14.0,
      width: MediaQuery.of(context).size.width/1.4,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          border: Border.all(
              color: Colors.white
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: fieldIdentifier,
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'FiraSansExtraCondensed',
                ),
                border: InputBorder.none
            ),
            style: TextStyle(
                color: Colors.black
            ),
            controller: controller,
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width*0.6,
      decoration: BoxDecoration(
          color: Colors.orangeAccent.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          border: Border.all(
              color: Colors.orange
          )
      ),
      child: TextButton(
        onPressed: () {_getAuthStatus();},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.1)
          ),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0)
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
