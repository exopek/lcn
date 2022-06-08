import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:xml/xml.dart';

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
  late List<bool> _yearOperatorStates;
  late bool check;
  List<String> _operatorsDummys = ['=', '!=', '<=', '>=', '<', '>'];
  late List<bool> _daysOfWeekStatus;

  void _showChangeTimeDialog(int index) => showDialog(
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
                        decoration: InputDecoration(
                            hintText: '00',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3)
                          )
                        ),
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
                        decoration: InputDecoration(
                            hintText: '00',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3)
                            )
                        ),
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
                        decoration: InputDecoration(
                          hintText: '00',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3)
                            )
                        ),
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
                      String _time = '${_controllerHour.text}:${_controllerMinutes.text}:${_controllerSeconds.text}';
                      setState(() {
                        _eventTimes[index] = _time;
                        Navigator.pop(context);
                      });

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


  void _changeDaysOfWeek(List<XmlAttribute> daysOfWeek, bool state, int day) {
    List<XmlAttribute> _changedList = daysOfWeek;
    XmlAttribute _weekDay = _changedList[day+2];
    _weekDay.value = state.toString();
  }

  List<XmlAttribute> _sortDaysOfWeek(List<XmlAttribute> daysOfWeek) {
    /// Notiz daysOfWeek einmal mit .toList kopieren damit das Model nicht verändert wird
    List<XmlAttribute> _sortedList = daysOfWeek.toList();
    _sortedList.removeAt(0);
    _sortedList.removeAt(0);
    return _sortedList;
  }

  List<bool> _operatorSelection(XmlAttribute attribute) {
    List<String> _operators = ['=', '!=', '<=', '>=', '<', '>'];
    List<bool> _selection = [];
    _operators.forEach((element) {
      if (element == attribute.value) {
        _selection.add(true);
      } else {
        _selection.add(false);
      }
    });
    return _selection;
  }

  void _changeOperator(int index, XmlAttribute attribute) {
    List<String> _operators = ['=', '!=', '<=', '>=', '<', '>'];
    attribute.value = _operators[index];
  }

  void _countUpYear(XmlAttribute attribute) {
    int value = int.parse(attribute.value);
    value = value + 1;
    attribute.value = value.toString();
  }

  void _countDownYear(XmlAttribute attribute) {
    int value = int.parse(attribute.value);
    value = value - 1;
    attribute.value = value.toString();
  }

  List<Map> _initWeekDays(int index) {
    List<Map> weekDays = [];
    _daysOfWeekStatus = [];
    _sortDaysOfWeek(widget.event.rules[index][0]).forEach((element) {
      if (element.value == "true") {
        _daysOfWeekStatus.add(true);
      } else {
        _daysOfWeekStatus.add(false);
      }
    });
    weekDays = [
      {"name": "Mo", "isChecked": _daysOfWeekStatus[0]},
      {"name": "Di", "isChecked": _daysOfWeekStatus[1]},
      {"name": "Mi", "isChecked": _daysOfWeekStatus[2]},
      {"name": "Do", "isChecked": _daysOfWeekStatus[3]},
      {"name": "Fr", "isChecked": _daysOfWeekStatus[4]},
      {"name": "Sa", "isChecked": _daysOfWeekStatus[5]},
      {"name": "So", "isChecked": _daysOfWeekStatus[6]},
    ];
    return weekDays;
  }

  @override
  void initState() {

    _daysOfWeekStatus = [];
    _sortDaysOfWeek(widget.event.rules[0][0]).forEach((element) {
      if (element.value == "true") {
        _daysOfWeekStatus.add(true);
      } else {
        _daysOfWeekStatus.add(false);
      }
    });
    /*
    _sortDaysOfWeek(widget.event.rule['DaysOfWeek']).forEach((element) {
      if (element.value == "true") {
        _daysOfWeekStatus.add(true);
      } else {
        _daysOfWeekStatus.add(false);
      }

    });

     */


    //List _daysOfWeekStatus = [false, false, false, false, false, false, false,];
    _weekDays = [
      {"name": "Mo", "isChecked": _daysOfWeekStatus[0]},
      {"name": "Di", "isChecked": _daysOfWeekStatus[1]},
      {"name": "Mi", "isChecked": _daysOfWeekStatus[2]},
      {"name": "Do", "isChecked": _daysOfWeekStatus[3]},
      {"name": "Fr", "isChecked": _daysOfWeekStatus[4]},
      {"name": "Sa", "isChecked": _daysOfWeekStatus[5]},
      {"name": "So", "isChecked": _daysOfWeekStatus[6]},
    ];

    /// XmlAttribute [,,,operator="="]
    _yearOperatorStates = _operatorSelection(widget.event.rules[0][1][3]);

    check = false;
    _controllerName = TextEditingController();
    _controllerHour = TextEditingController();
    _controllerMinutes = TextEditingController();
    _controllerSeconds = TextEditingController();
    _controllerName.text = widget.event.name;
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
                      height: 20,
                      width: 20,
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
                            overlayColor: MaterialStateProperty.all(Colors.amber.withOpacity(0.1)),
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
                            _weekDays = _initWeekDays(index);
                            _yearOperatorStates = _operatorSelection(widget.event.rules[index][1][3]);
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
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.0,
              )
              ),
              SliverToBoxAdapter(child: _header(context, 'Zeit'),),
              SliverToBoxAdapter(child: _time(context, _eventTimes[_timerIndex], Icon(Icons.watch_later_outlined), _timerIndex),),
              SliverToBoxAdapter(child: _header(context, 'Bedingungen'),),
              SliverList(
                  delegate: SliverChildBuilderDelegate(

                      (context, index) {
                        return _rules(context, widget.event.rules[_timerIndex][index].first.value, Icon(Icons.calendar_view_week));
                      },
                    childCount: widget.event.rules[_timerIndex].length
                  )
              ),
              //SliverToBoxAdapter(child: _header(context, 'Zustand'),),
              SliverToBoxAdapter(child: _switchOnOff(context, 'Speichern', Icon(Icons.save_outlined), widget.id),)
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
                futureSettingTimer.setTimerOptions(customData: widget.event, timerName: _controllerName.text);
                //futureDeleteTimer.deleteTimer(id: id);
                //futureSettingTimer.setTimerEnabled(timerEnabled: 'true');
            });
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.amber.withOpacity(0.1)),
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

            contentPadding: EdgeInsets.only(left: 100),
            title: Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),
            //trailing: Icon(Icons.power_settings_new_outlined, color: _enabled ? Colors.greenAccent : Colors.redAccent,),
          ),
        ),
      ),
    );
  }

  Widget _time(BuildContext context, String name, Icon icon, int index) {
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
            _showChangeTimeDialog(index);
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

  Widget _daysOfWeek(BuildContext context) {
    _weekDays = [
      {"name": "Mo", "isChecked": _daysOfWeekStatus[0]},
      {"name": "Di", "isChecked": _daysOfWeekStatus[1]},
      {"name": "Mi", "isChecked": _daysOfWeekStatus[2]},
      {"name": "Do", "isChecked": _daysOfWeekStatus[3]},
      {"name": "Fr", "isChecked": _daysOfWeekStatus[4]},
      {"name": "Sa", "isChecked": _daysOfWeekStatus[5]},
      {"name": "So", "isChecked": _daysOfWeekStatus[6]},
    ];
    return Row(
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
    );
  }

  Widget _year(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: ScrollController(),
            itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Container(
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: _yearOperatorStates[index] ? Colors.orange : Colors.black),
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              _changeOperator(index, widget.event.rule['Year'][3]);
                            });
                          },
                          child: Text(
                            _operatorsDummys[index],
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    /// XmlAttribute [,,noYear="2022",]
                    _countDownYear(widget.event.rule['Year'][2]);
                  });
                },
                icon: Icon(
                    Icons.arrow_back_ios,
                  color: Colors.white,
                )
            ),
            Text(
              widget.event.rule['Year'][2].value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    _countUpYear(widget.event.rule['Year'][2]);
                  });
                },
                icon: Icon(
                    Icons.arrow_forward_ios,
                  color: Colors.white,
                )
            )
          ],
        )
      ],
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
        child: ExpansionTile(
            title: Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),
            children: [
              if (name == 'DaysOfWeek')
                 /// <Rule xsi:type="DaysOfWeek" allow="true" mo="false" tu="false" we="false" th="true" fr="true" sa="true" su="true">
                _daysOfWeek(context),
              if (name == 'Year')
                /// <Rule xsi:type="Year" allow="true" yearNo="2024" operator="&lt;=" />
                _year(context)
            ],
          ),
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
                _changeDaysOfWeek(widget.event.rule['DaysOfWeek'], !state, day);
              });
            }
        )
      ],
    );
  }

  /// Rules Widgets
  /// DaysOfWeek
  ///
  /*
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
  */

}
