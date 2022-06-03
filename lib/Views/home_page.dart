import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Providers/state_provider.dart';
import 'package:lcn/Views/administration_page.dart';
import 'package:lcn/Views/tableau_page.dart';
import 'package:lcn/Views/webview_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final List tableauNames;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    print('HomePage names');
    //print(widget.tableauNames);
    //print(widget.tableauNames[0]['Value']);

  }


  @override
  Widget build(BuildContext context) {
    ref.listen(customTableauListProvider, (previous, next) {
      setState(() {

      });
    });
    final futureGetTableaus = ref.watch(futureGetTableausProvider);

    final List customTableaus = ref.read(customTableauListProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white10,
        selectedItemColor: Colors.amber,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdministrationPage())
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.17,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: customTableaus.length,
                  itemBuilder: (context, index) {
                    return _lastTableaus(context, customTableaus[index]['Value'], {'Strings': customTableaus});
                  }
              )
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                child: futureGetTableaus.when(
                          data: (data) => ListView.builder(
                            physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map _tempData = data[index];
                                return _tableauGroupsContent(context, _tempData.keys.first, _tempData.values.first);
                          },
                            itemCount: data.length,
                ),
                error: (e, st) => Container(child: Text(e.toString(), style: TextStyle(color: Colors.white),),),
                loading: () => CircularProgressIndicator()
              )
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _tableauGroupsContent(BuildContext context, String name, List tableauContent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: RadialGradient(
            radius: 5,
            colors: [
              Colors.black,
              Colors.grey
            ],

          ),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableauPage(tableauElements: tableauContent, tableauGroupName: name,))
            );
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.amber),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
              ))
          ),
          child: ListTile(
            leading: Icon(
                Icons.home_filled,
                color: Colors.amber,
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lastTableaus(BuildContext context, String name, Map customData) {
    final customTableausProvider = ref.read(customTableauListProvider.state);
    final setUserCustomData = ref.read(dioAuthProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
      child: Container(
        //height: MediaQuery.of(context).size.height*0.0,
        //width: MediaQuery.of(context).size.height*0.16,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 2,
            colors: [
              Colors.black,
              Colors.grey
            ],

          ),
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.amber),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ))
          ),
          onPressed: () {
            setUserCustomData.getUserCustomData(customData: customData, currentUri: name);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebViewPage(title: name.split(RegExp(r"\\")).last, url: 'http://access.lcn.de/LCNGVSDemo/control.aspx?ui=${name.split(RegExp(r"\\")).last}&proj=${name.split(RegExp(r"\\")).first}&loginName=gast&password=lcn'))
            );
          },
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              Icon(
                  Icons.home_filled,
                color: Colors.amber,
              ),
              Container(
                child: Center(
                  child: Text(
                    name.split(RegExp(r"\\")).last,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


