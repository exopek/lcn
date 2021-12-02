import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lcn/Views/home_page.dart';
import 'package:lcn/Views/logout_page.dart';
import 'package:lcn/Views/makro_page.dart';
import 'package:lcn/Views/status_page.dart';
import 'package:lcn/Views/timer_page.dart';

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({Key? key}) : super(key: key);

  @override
  _AdministrationPageState createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {

  late List<Widget> _serviceList;
  late List<String> _serviceName;
  late List<Icon> _serviceIcon;


  @override
  void initState() {
    super.initState();
    _serviceList = [StatusPage(), LogoutPage(),LogoutPage(),LogoutPage(),MakroPage(),TimerPage()];
    _serviceName = ['Status', 'Logout', 'InBox', 'Favoriten', 'Makros', 'Zeitschaltuhr'];
    _serviceIcon = [Icon(Icons.info), Icon(Icons.logout), Icon(Icons.inbox), Icon(Icons.star), Icon(Icons.list),Icon(Icons.watch_later)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white10,
        selectedItemColor: Colors.amber,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage())
            );
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Tableaus'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              label: 'Administration'
          )
        ],
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
              itemCount: 6,
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
