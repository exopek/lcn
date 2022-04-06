import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lcn/Views/home_page.dart';
import 'package:lcn/Views/logout_page.dart';
import 'package:lcn/Views/makro_page.dart';
import 'package:lcn/Views/status_page.dart';
import 'package:lcn/Views/timer_page.dart';

import 'melder_settings_page.dart';

class EreignismelderPage extends StatefulWidget {
  const EreignismelderPage({Key? key}) : super(key: key);

  @override
  _EreignismelderPageState createState() => _EreignismelderPageState();
}

class _EreignismelderPageState extends State<EreignismelderPage> {

  late List<Widget> _serviceList;
  late List<String> _serviceName;
  late List<Icon> _serviceIcon;


  @override
  void initState() {
    super.initState();
    _serviceList = [StatusPage(), LogoutPage(),MelderSettingsPage()];
    _serviceName = ['Nachrichten einrichten', 'Nachrichten', 'Melder einrichten'];
    _serviceIcon = [Icon(Icons.messenger_outline), Icon(Icons.message), Icon(Icons.warning)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Ereignismelder',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 2,
                        colors: [
                          Colors.black,
                          Colors.grey
                        ],

                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: TextButton.icon(
                    icon: Icon(
                      _serviceIcon[index].icon,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => _serviceList[index])
                      );
                    },

                    label: Text(
                      _serviceName[index],
                      style: TextStyle(
                          color: Colors.amber
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
