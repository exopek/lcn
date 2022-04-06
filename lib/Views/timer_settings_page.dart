import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';

class TimerSettingsPage extends ConsumerStatefulWidget {
  const TimerSettingsPage({Key? key, required this.event, required this.name, required this.id}) : super(key: key);

  final Event event;
  final String name;
  final String id;

  @override
  _TimerSettingsPageState createState() => _TimerSettingsPageState();
}

class _TimerSettingsPageState extends ConsumerState<TimerSettingsPage> {

  late TextEditingController _controllerName;
  late TextEditingController _controllerHour;
  late TextEditingController _controllerMinutes;
  late TextEditingController _controllerSeconds;
  late int _timerIndex;
  late List _eventTimes;
  late bool _enabled;
  late List<Map> _weekDays;

  void _showChangeTimeDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.7,
          color: Color.fromRGBO(19, 19, 19, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 20,
                      width: 70,
                      child: TextField(
                        controller: _controllerHour,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      ':',
                      style: TextStyle(
                          color: Colors.amber
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 20,
                      width: 70,
                      child: TextField(
                        controller: _controllerMinutes,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                        ':',
                      style: TextStyle(
                        color: Colors.amber
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 20,
                      width: 70,
                      child: TextField(
                        controller: _controllerSeconds,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      ),
                    ),
                  )
                ],
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

                    },
                    child: Text(
                      'Speichern',
                      style: TextStyle(
                        color: Colors.amber
                      ),
                    )),
              )
            ],
          ),
        ),
      )
  );


  ///
  void _showChangeRulesDialog({required String rule}) => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.7,
          color: Color.fromRGBO(19, 19, 19, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  rule,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Builder(
                  builder: (context) {
                    if (rule == 'DaysOfWeek') {
                      return Container(
                          height: 100,
                          child: _daysOfWeek(context));
                    } else if (rule == 'Year') {
                      return Container(
                        height: 100,
                        child: Container(color: Colors.green,),
                      );
                    } else {
                      return Container(
                        height: 100,
                      );
                    }

                  }
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

                    },
                    child: Text(
                      'Speichern',
                      style: TextStyle(
                          color: Colors.amber
                      ),
                    )),
              )
            ],
          ),
        ),
      )
  );
  ///


  late bool check;

  @override
  void initState() {

    _weekDays = [
      {"name": "Mo", "isChecked": false},
      {"name": "Di", "isChecked": false},
      {"name": "Mi", "isChecked": false,},
      {"name": "Do", "isChecked": false},
      {"name": "Fr", "isChecked": false},
      {"name": "Sa", "isChecked": false},
      {"name": "So", "isChecked": false},
    ];



    check = false;
    _controllerName = TextEditingController();
    _controllerHour = TextEditingController();
    _controllerMinutes = TextEditingController();
    _controllerSeconds = TextEditingController();
    _controllerName.text = widget.name;
    _timerIndex = 0;
    _eventTimes = widget.event.times;
    if (widget.event.enabled == 'true') {
      _enabled = true;
    } else {
      _enabled = false;
    }
    //_eventTimes.add('+');
    //_controllerTime.text = widget.event.times[0];
    //print(widget.times);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final futureSettingTimer = ref.read(dioTimerProvider);
    //futureSettingTimer.setTimerOptions(customData: widget.event);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Timer Einstellungen',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _timerSettings(context, identifier: 'Name', controller: _controllerName),
              ),
              SliverGrid(
              delegate: SliverChildBuilderDelegate(

              (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                      child: TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.amber),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                            ))
                        ),
                        /*
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.amber,
                                ),
                                */
                        onPressed: () {
                          setState(() {
                            _timerIndex = index;
                          });
                        },

                        child: Text(
                          _eventTimes[index],
                          style: TextStyle(
                              color: Colors.amber
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _eventTimes.length
              ),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
              )
              ),
              SliverToBoxAdapter(child: _header(context, 'Zeit'),),
              SliverToBoxAdapter(child: _time(context, _eventTimes[_timerIndex], Icon(Icons.watch_later_outlined)),),
              SliverToBoxAdapter(child: _header(context, 'Bedingungen'),),
              SliverList(
                  delegate: SliverChildBuilderDelegate(

                      (context, index) {
                        return _rules(context, widget.event.rules[_timerIndex][index].first.value, Icon(Icons.calendar_view_week));
                      },
                    childCount: widget.event.rules[_timerIndex].length
                  )
              ),
              SliverToBoxAdapter(child: _header(context, 'Zustand'),),
              SliverToBoxAdapter(child: _switchOnOff(context, 'Status Timer Event', Icon(Icons.watch_later_outlined), widget.id),)
            ]
        ),
    );
  }

  Widget _header(BuildContext context, String headerText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 140,
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              //padding: const EdgeInsets.all(10.0),
              child: Text(headerText,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18.0
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timerSettings(BuildContext context, {required String identifier, required TextEditingController controller}) {
    return ListTile(
      leading: Icon(Icons.edit,color: Colors.amber,),
      title: Text(
        identifier,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0
        ),
      ),
      trailing: Container(
        height: 50,
        width: 200,
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _timerTimeSettings(BuildContext context, {required String identifier, required String value}) {
    return ListTile(
      leading: Icon(Icons.edit,color: Colors.amber,),
      title: Text(
        identifier,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
        ),
      ),
      trailing: Container(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.white,
              fontSize: 18.0
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchOnOff(BuildContext context, String name, Icon icon, String id) {
    final futureDeleteTimer = ref.read(dioTimerProvider);
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
        child: TextButton(
          onPressed: () {
            setState(() {
              if (_enabled == false) {
                _enabled = true;
                futureSettingTimer.setTimerOptions(customData: widget.event);
                //futureDeleteTimer.deleteTimer(id: id);
                //futureSettingTimer.setTimerEnabled(timerEnabled: 'true');
              } else {
                _enabled = false;
                futureSettingTimer.setTimerOptions(customData: widget.event);
                //futureDeleteTimer.deleteTimer(id: id);
                //futureSettingTimer.setTimerEnabled(timerEnabled: 'false');
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
            trailing: Icon(Icons.power_settings_new_outlined, color: true ? Colors.greenAccent : Colors.redAccent,),
          ),
        ),
      ),
    );
  }

  Widget _time(BuildContext context, String name, Icon icon) {
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
            _showChangeTimeDialog();
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
            trailing: Icon(Icons.edit, color: Colors.amber,),
          ),
        ),
      ),
    );
  }


  Widget _rules(BuildContext context, String name, Icon icon) {
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
        child:/* TextButton(
          onPressed: () {
            _showChangeRulesDialog(rule: name);
            /*
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerSettingsPage(name: name, times: time,))
            );

             */
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.amber),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
              ))
          ),
          child:*/ ExpansionTile(
            /*
            leading: Icon(
              icon.icon,
              color: Colors.amber,
              size: 30.0,
            ),

             */
            title: Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _checkBox(context, _weekDays[0]['name'], _weekDays[0]['isChecked'], 0),
                  _checkBox(context, _weekDays[1]['name'], _weekDays[1]['isChecked'], 1),
                  _checkBox(context, _weekDays[2]['name'], _weekDays[2]['isChecked'], 2),
                  _checkBox(context, _weekDays[3]['name'], _weekDays[3]['isChecked'], 3),
                  _checkBox(context, _weekDays[4]['name'], _weekDays[4]['isChecked'], 4),
                  _checkBox(context, _weekDays[5]['name'], _weekDays[5]['isChecked'], 5),
                  _checkBox(context, _weekDays[6]['name'], _weekDays[6]['isChecked'], 6),

                ]



              )
            ],
            //trailing: Icon(Icons.edit, color: Colors.amber,),
          ),
       // ),
      ),
    );
  }

  Widget _checkBox(BuildContext context, String weekDay, bool state, int day) {
    return Column(
      children: [
        Text(weekDay,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        Checkbox(
            value: state,
            key: Key(weekDay),
            side: BorderSide(color: Colors.orangeAccent),
            activeColor: Colors.transparent,
            checkColor: Colors.greenAccent,
            onChanged: (value) {
              setState(() {
                _weekDays[day]['isChecked'] = !state;

              });
            }
        )
      ],
    );
  }

  /// Rules Widgets
  /// DaysOfWeek
  Widget _daysOfWeek(BuildContext context) {
    List _weekDays = [];
    return SizedBox(
      child: ListView.builder(
          itemBuilder: (context, index) {
            return TextButton(
              onPressed: () {
                print(widget.event.rules);
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.amber),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ))
              ),
              child: ListTile(
                title: Text(
                  _weekDays[index],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
                trailing: Icon(Icons.check_circle, color: Colors.greenAccent),
              ),
            );
          },
          itemCount: 7,
      ),
    );
  }

}
