import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Views/administration_page.dart';
import 'package:lcn/Views/tableau_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final List tableauNames;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final futureGetTableaus = ref.watch(futureGetTableausProvider);
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.15,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _lastTableaus(context, 'bla');
                },

            ),
          ),
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: futureGetTableaus.when(
                        data: (data) => ListView.builder(
                            itemBuilder: (context, index) {
                              return _tableauGroupsContent(context, data.data['d']['Items'][index]['Name'], data.data['d']['Items'][index]['Tableaus']);
                        },
                          itemCount: data.data['d']['Items'].length,
              ),
              error: (e, st) => Container(child: Text(e.toString()),),
              loading: () => CircularProgressIndicator()
            )
            ),
          )
        ],
      ),
    );
  }

  Widget _loading() {
    return ListTile(
      leading: CircularProgressIndicator(),
    );
  }

  Widget _tableauGroupsContent(BuildContext context, String name, List tableauContent) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TableauPage(tableauElements: tableauContent, tableauGroupName: name,))
        );
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.amber)
      ),
      child: ListTile(
        leading: Icon(
            Icons.home_filled,
            color: Colors.amberAccent,
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    );
  }

  Widget _lastTableaus(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height*0.0,
        width: MediaQuery.of(context).size.height*0.16,
        color: Colors.grey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.03,
            ),
            TextButton.icon(
                onPressed: () {

                },
                icon: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 30.0,
                ),
                label: Text('')
            ),
            Container(
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


