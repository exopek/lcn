import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Helper/helper.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:lcn/Services/timer_service.dart';
import 'package:lcn/Views/timer_settings_page.dart';
import 'package:xml/xml.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {

  late bool _edit;

  void _changeTimerEnabled(bool enabled, Event event, TimerService timerService)  {
    Map<String, dynamic> tmpEvent = Event.fromMap(event.toMap()).toMap();
    tmpEvent['enabled'] = enabled.toString();
    timerService.setTimerOptions(customData: Event.fromMap(tmpEvent), timerName: event.name);
  }

  @override
  void initState() {
    _edit = false;
  }

  @override
  Widget build(BuildContext context) {
    //final futureGetTimer = ref.watch(futureGetTimerProvider);
    final futureSettingTimer = ref.read(dioTimerProvider);
    print(futureSettingTimer.runtimeType);
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
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (_edit == true) {
                  _edit = false;
                } else {
                  _edit = true;
                }
              });
            },
            child: Text(
              'Bearbeiten',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
      body: Stack(
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
          //_listContent(context, data[index].name, data[index].times[0], data[index], data[index].id);
        Container(
          child: FutureBuilder<List<Event>> (
            future: futureSettingTimer.getTimerEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _listContent(context, snapshot.data![index].name, snapshot.data![index], snapshot.data![index].id, snapshot.data![index].enabled);
                  }
                );
              } else if (snapshot.hasError) {
                return Container(child: Text(snapshot.error.toString()),);
              } else {
                return Center(
                    child: CircularProgressIndicator()
                );
              }

            },
          ),
        ),

        _edit ? Padding(
          padding: EdgeInsets.only(right: 10.0, bottom: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.add),
                onPressed: () {
                setState(() {
                  futureSettingTimer.setTimerOptions(customData: Event(name: 'Mein Timer', id: Helper().guid(), enabled: 'false', times: [], rules: [], rule: {}), timerName: 'Mein Timer');
                });
                }
                ),
          ),
        ) : FutureBuilder<bool>(
          future: futureSettingTimer.isTimerEnabled(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(right: 10.0, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.power_settings_new_outlined, color: snapshot.data! ? Colors.greenAccent : Colors.redAccent,),
                      onPressed: () {
                        setState(() {
                          if (snapshot.data == false) {
                            futureSettingTimer.setTimerEnabled(timerEnabled: 'true');
                          } else {
                            futureSettingTimer.setTimerEnabled(timerEnabled: 'false');
                          }
                        });
                      }
                  ),
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

          }
        ),


        /*
          Container(
            child: futureGetTimer.when(
                data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return _listContent(context, data[index].name, data[index].times[0], data[index], data[index].id);
                    }),
                error: (e, st) => Container(child: Text(e.toString()),),
                loading: () => CircularProgressIndicator()),
          ),
        */
          /*
          Align(
            alignment: Alignment.bottomCenter,
            child: _switchOnOff(context, 'Zeitschaltuhr deaktivieren', Icon(Icons.watch_later_outlined)),
          )

           */


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
        /// Status ändert sich sich hier nur mit dem Neuladen der Seite
        /// Eine Möglichkeit ist hier vielleicht dauerhaft zu pollen oder websockets
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
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }


  Widget _listContent(BuildContext context, String name, Event event, String id, String enabled) {
    final futureSettingTimer = ref.read(dioTimerProvider);
    bool _enabled = false;
    if (enabled == 'true') {
      _enabled = true;
    } else {
      _enabled = false;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Stack(
        children: [
          _edit ? Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: RadialGradient(
                radius: 5,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Color.fromRGBO(60, 60, 59, 0.1)
                  //Colors.grey.withOpacity(0.1)
                ],

              ),
            ),
            child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.3)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ))
                ),
                onPressed: () {
                  setState(() {
                    /// API zum löschen eines ganzen Events
                    futureSettingTimer.deleteTimer(id: event.id);
                    //futureSettingTimer.setTimerOptions(customData: event, timerName: name);
                    //widget.event.rules[_timerIndex].remove(name);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                )
            ),
          ) : Container(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: RadialGradient(
                radius: 5,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Color.fromRGBO(60, 60, 59, 0.1)
                  //Colors.grey.withOpacity(0.1)
                ],

              ),
            ),
              /*
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimerSettingsPage(name: name, event: event, id: id)
                    )
                );
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.amber.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ))
              ),
              */
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.watch_later_outlined,
                      color: Color.fromRGBO(255, 208, 11, 1),
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
                      event.times.isNotEmpty ? event.times[0] : 'Trage eine Zeit ein',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TimerSettingsPage(name: name, event: event, id: id)
                                )
                            );

                        },
                        icon: Icon(
                            Icons.settings,
                          color: Color.fromRGBO(255, 208, 11, 1),
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Switch(
                          value: _enabled,
                          onChanged: (value) {
                            setState(() {
                              _changeTimerEnabled(value, event, futureSettingTimer);
                            });
                          } ,
                        ),
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
}
