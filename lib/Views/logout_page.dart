import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

import 'login_page.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    final futureLogout = ref.watch(futureLogoutProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Logout',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
          child: GridView.builder(
            itemCount: 2,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
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
                      Icons.logout,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      futureLogout.when(
                          data: (data) {
                            print(data.data);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                          );
                          },
                          error: (e, st) => Container(child: Text(e.toString()),),
                          loading: () => CircularProgressIndicator()
                      );
                    },

                    label: Text(
                      'Logout',
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
