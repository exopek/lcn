import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Views/timer_settings_page.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {
  @override
  Widget build(BuildContext context) {
    final futureGetTimer = ref.watch(futureGetTimerProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Auslösezeiten',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Stack(
        children: [

          Container(
            child: futureGetTimer.when(
                data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //return Container();
                      print('---------------------ID der Timer------------------------');
                      print('Timer $index: ${data[index].id}');
                      return _listContent(context, data[index].name, data[index].times[0], data[index], data[index].id);
                    }),
                error: (e, st) => Container(child: Text(e.toString()),),
                loading: () => CircularProgressIndicator()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _switchOnOff(context, 'Status Timer', Icon(Icons.watch_later_outlined)),
          )


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


  Widget _switchOnOff(BuildContext context, String name, Icon icon) {
    final futureSettingTimer = ref.read(dioTimerProvider);
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
        child: FutureBuilder<bool>(
          future: futureSettingTimer.isTimerEnabled(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return TextButton(
                onPressed: () {
                  setState(() {
                    if (snapshot.data == false) {
                      futureSettingTimer.setTimerEnabled(timerEnabled: 'true');
                    } else {
                      futureSettingTimer.setTimerEnabled(timerEnabled: 'false');
                    }

                  });
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.amber),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                    ))
                ),
                child: ListTile(
                  leading: Icon(
                    icon.icon,
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
                  trailing: Icon(Icons.power_settings_new_outlined, color: snapshot.data! ? Colors.greenAccent : Colors.redAccent,),
                ),
              );
            } else {
              return Container(color: Colors.greenAccent,);
            }
          }
        ),
      ),
    );
  }


  Widget _listContent(BuildContext context, String name, String time, Event event, String id) {
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
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerSettingsPage(name: name, event: event,id: id,))
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
              time,
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
