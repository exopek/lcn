import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class MakroPage extends ConsumerStatefulWidget {
  const MakroPage({Key? key}) : super(key: key);

  @override
  _MakroPageState createState() => _MakroPageState();
}

class _MakroPageState extends ConsumerState<MakroPage> {

  void _showChangeTimeDialog(String macroName) => showDialog(
      context: context,
      builder: (context) {
        final makroProvider = ref.watch(dioMakroProvider);
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width*0.7,
            color: Color.fromRGBO(19, 19, 19, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 200,
                  child: TextButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.amber
                          ))
                      ),
                      onPressed: () {
                        makroProvider.executeMacro(macroName: macroName);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Makro Ausführen',
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      )),
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: TextButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.amber
                          ))
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Abbrechen',
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      }
  );


  @override
  Widget build(BuildContext context) {
    final futureGetMakro = ref.watch(futureGetMakroProvider);
    final makroProvider = ref.watch(dioMakroProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Makros',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: futureGetMakro.when(
            data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {

                  return _listContent(context, data[index].name, data[index].description);
                }),
            error: (e, st) => Container(child: Text(e.toString()),),
            loading: () => CircularProgressIndicator()),
      ),
    );
  }


  Widget _listContent(BuildContext context, String name, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          style: ButtonStyle(

              overlayColor: MaterialStateProperty.all(Colors.amber.withOpacity(0.2))
          ),
          onPressed: () {
            _showChangeTimeDialog(name);
          },
          child: ListTile(
            subtitle: Text(
                description,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14.0
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),

          ),
        ),
      ),
    );
  }
}
