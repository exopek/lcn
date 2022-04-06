import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Views/timer_settings_page.dart';

class MelderSettingsPage extends ConsumerStatefulWidget {
  const MelderSettingsPage({Key? key}) : super(key: key);

  @override
  _MelderSettingsPageState createState() => _MelderSettingsPageState();
}

class _MelderSettingsPageState extends ConsumerState<MelderSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final futureGetMonitoringEvents = ref.watch(futureGetMonitoringEventsProvider);
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
      body: Stack(
        children: [
          Container(
            child: futureGetMonitoringEvents.when(
                data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //return Container();
                      print(data);
                      return _listContent(context, data[index]['Description']);
                    }),
                error: (e, st) => Container(child: Text(e.toString()),),
                loading: () => CircularProgressIndicator()),
          ),
          /*
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              child: Icon(Icons.add),
                onPressed: () {

                }),
          )
          */
        ],
      ),
    );
  }


  Widget _listContent(BuildContext context, String name) {
    print(name);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
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
            /*
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerSettingsPage(name: name, event: event,))
            );

             */
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.amber),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
              ))
          ),
          child: ListTile(
            leading: Icon(
              Icons.watch_later_outlined,
              color: Colors.amber,
              size: 30.0,
            ),
            title: Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),
            subtitle: Text(
              name,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12.0
              ),
            ),

          ),
        ),
      ),
    );
  }
}
