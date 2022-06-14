import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Helper/helper.dart';
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
  late List<String> _conditions;
  late bool _showConditions;
  late Map<String, bool> _conditionsState;
  late List<bool> _eventTimesState;
  late bool _edit;
  //late List<bool> _daysOfWeekStatus;

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


  void _changeDaysOfWeek(Map<String, dynamic> daysOfWeek, bool state, String day) {
    daysOfWeek[day] = state.toString();
  }

  /*
  List<XmlAttribute> _sortDaysOfWeek(Map daysOfWeek) {
    /// Notiz daysOfWeek einmal mit .toList kopieren damit das Model nicht verändert wird
    List<XmlAttribute> _sortedList = daysOfWeek.toList();
    _sortedList.removeAt(0);
    _sortedList.removeAt(0);
    return _sortedList;
  }

   */

  List<bool> _operatorSelection(String attribute) {
    List<String> _operators = ['=', '!=', '<=', '>=', '<', '>'];
    List<bool> _selection = [];
    _operators.forEach((element) {
      if (element == attribute) {
        _selection.add(true);
      } else {
        _selection.add(false);
      }
    });
    return _selection;
  }

  void _changeOperator(int index, Map rule) {
    List<String> _operators = ['=', '!=', '<=', '>=', '<', '>'];
    rule['operator'] = _operators[index];
  }

  void _countUpYear(Map rule) {
    int value = int.parse(rule['yearNo']);
    value = value + 1;
    rule['yearNo'] = value.toString();
  }

  void _countDownYear(Map rule) {
    int value = int.parse(rule['yearNo']);
    value = value - 1;
    rule['yearNo'] = value.toString();
  }

  List<Map> _initWeekDays(int index) {
    List<Map> _weekDays = [];
    List _daysOfWeekStatus = [];

    widget.event.rules[index]['DaysOfWeek']!.forEach((key, value) {
      if (value == "true") {
        _daysOfWeekStatus.add(true);
      } else {
        _daysOfWeekStatus.add(false);
      }
    });
    _weekDays = [
      {"name": "mo", "isChecked": _daysOfWeekStatus[0]},
      {"name": "tu", "isChecked": _daysOfWeekStatus[1]},
      {"name": "we", "isChecked": _daysOfWeekStatus[2]},
      {"name": "th", "isChecked": _daysOfWeekStatus[3]},
      {"name": "fr", "isChecked": _daysOfWeekStatus[4]},
      {"name": "sa", "isChecked": _daysOfWeekStatus[5]},
      {"name": "su", "isChecked": _daysOfWeekStatus[6]},
    ];
    return _weekDays;
  }

  @override
  void initState() {


    if (widget.event.rules.isNotEmpty) {
      if (widget.event.rules[0].containsKey('DaysOfWeek')) {
        _weekDays = _initWeekDays(0);
      } else {
        _weekDays = [
          {"name": "mo", "isChecked": false},
          {"name": "tu", "isChecked": false},
          {"name": "we", "isChecked": false},
          {"name": "th", "isChecked": false},
          {"name": "fr", "isChecked": false},
          {"name": "sa", "isChecked": false},
          {"name": "su", "isChecked": false},
        ];
      }

      if (widget.event.rules[0].containsKey('Year')) {
        _yearOperatorStates = _operatorSelection(widget.event.rules[0]['Year']!['operator']);
      } else {
        _yearOperatorStates = [true, false, false, false, false, false];
      }
    }
    _edit = false;
    _eventTimesState = [true, false];
    _conditionsState = new Map();
    _showConditions = false;
    _conditions = ['DaysOfWeek', 'Year'];
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final futureSettingTimer = ref.read(dioTimerProvider);
    //futureSettingTimer.setTimerOptions(customData: widget.event);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: _showConditions ? AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _showConditions = false;
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if(_conditionsState['DaysOfWeek'] == true) {
                  if (widget.event.rules.isNotEmpty) {
                    widget.event.rules[_timerIndex]['DaysOfWeek'] = {'mo': 'false', 'tu': 'false', 'we': 'false', 'th': 'false', 'fr': 'false', 'sa': 'false', 'su': 'false'};
                    _weekDays = _initWeekDays(_timerIndex);
                  } else {
                    widget.event.rules.add({'DaysOfWeek': {'mo': 'false', 'tu': 'false', 'we': 'false', 'th': 'false', 'fr': 'false', 'sa': 'false', 'su': 'false',}});
                    _weekDays = _initWeekDays(_timerIndex);
                  }
                } else if (_conditionsState['Year'] == true) {
                  if (widget.event.rules.isNotEmpty) {
                    widget.event.rules[_timerIndex]['Year'] = {'yearNo': '2022', 'operator': '='};
                    _yearOperatorStates = _operatorSelection(widget.event.rules[_timerIndex]['Year']!['operator']);
                  } else {
                    widget.event.rules.add({'Year': {'yearNo': '2022', 'operator': '='}});
                  }
                }
                _showConditions = false;
              });
            },
            child: Text(
              'Hinzufügen',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          )
        ],
      ) : AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Timer Einstellungen',
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
      body: _showConditions ? _conditionSettings(context) : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _timerSettings(context, identifier: 'Name', controller: _controllerName),
              ),
              SliverToBoxAdapter(child: Row(
                children: [
                  _header(context, 'Timer'),
                  _edit ? IconButton(
                      onPressed: () {
                        setState(() {
                          /// eingabe für eine Zeit öffnen
                          _eventTimes.add('15:00:00');
                          widget.event.rules.add({});
                        });
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      )
                  ) : Container()
                ],
              ),),
              SliverGrid(
              delegate: SliverChildBuilderDelegate(

              (context, index) {
                  return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Stack(
                            children: [
                              _edit ? Container(
                                decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      radius: 2,
                                      colors: [
                                        Colors.black,
                                        _eventTimesState[index] ? Color(0xFFAABBAA) : Colors.grey
                                      ],

                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0)
                                        ))
                                    ),
                                    ///  Timer mit all seinen Eigenschaften löschen
                                    onPressed: () {
                                      setState(() {
                                        if (widget.event.rules.isNotEmpty) {
                                          widget.event.rules.removeAt(index);
                                        }
                                        _eventTimesState[index] = false;
                                        _eventTimes.removeAt(index);
                                        _timerIndex = 0;
                                        _eventTimesState[0] = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Container(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ) : Container(),
                              Container(
                                height: 100,
                                width: _edit ? 100 : 200,
                                decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      radius: 2,
                                      colors: [
                                        Colors.black,
                                        _eventTimesState[index] ? Color(0xFFAABBAA) : Colors.grey
                                      ],

                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
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
                                        _eventTimesState[_timerIndex] = false;
                                        _eventTimesState[index] = true;
                                        _timerIndex = index;

                                        if (index >= widget.event.rules.length) {
                                          widget.event.rules.add({});
                                        } else {
                                          print(widget.event.rules);
                                          if (widget.event.rules[index].containsKey('DaysOfWeek')) {
                                            _weekDays = _initWeekDays(index);
                                          }
                                          if (widget.event.rules[index].containsKey('Year')) {
                                            _yearOperatorStates = _operatorSelection(widget.event.rules[_timerIndex]['Year']!['operator']);
                                          }
                                        }


                                        //_yearOperatorStates = _operatorSelection(widget.event.rules[index][1][3]);
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
                              ),

                            ],
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
              _eventTimes.isNotEmpty ? SliverToBoxAdapter(child: _header(context, 'Zeit'),) : SliverToBoxAdapter(),
              _eventTimes.isNotEmpty ? SliverToBoxAdapter(child: _time(context, _eventTimes.isNotEmpty ? _eventTimes[_timerIndex] : '00:00:00', Icon(Icons.watch_later_outlined), _timerIndex),) : SliverToBoxAdapter(),
              SliverToBoxAdapter(child: Row(
                children: [
                  _header(context, 'Bedingungen'),
                  ///  Maske zum Anpassen der Bedingungen
                  _edit ? IconButton(
                      onPressed: () {
                        setState(() {
                          _showConditions = true;
                          /*
                          if (widget.event.rules.isNotEmpty) {
                            widget.event.rules[_timerIndex]['DaysOfWeek'] = {'mo': 'false', 'tu': 'false', 'we': 'false', 'th': 'false', 'fr': 'false', 'sa': 'false', 'su': 'false'};
                            widget.event.rules[_timerIndex]['Year'] = {'yearNo': '2022', 'operator': '='};
                          } else {
                            widget.event.rules.add({'DaysOfWeek': {'mo': 'false', 'tu': 'false', 'we': 'false', 'th': 'false', 'fr': 'false', 'sa': 'false', 'su': 'false',}});
                            _weekDays = _initWeekDays(0);
                          }

                           */

                          /*
                              .add([Helper().buildRulesDayOfWeek(
                              type: 'Rule',
                              xsiType: 'DaysOfWeek',
                              attribute_allow: 'true',
                              attribute_mo: 'false',
                              attribute_tu: 'false',
                              attribute_we: 'false',
                              attribute_thu: 'false',
                              attribute_fr: 'false',
                              attribute_sa: 'false',
                              attribute_su: 'false'
                          )
                          ]
                          );
                          */
                          /*
                          widget.event.rules.add([Helper().buildRulesYear(
                              type: 'Rule',
                              xsiType: 'Year',
                              attribute_allow: 'true',
                              attribute_year: '2022',
                              attribute_op: '=')]);
                          */
                          //print(widget.event);
                        });

                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      )
                  ) : Container()
                ],
              ),),
              SliverList(
                  delegate: SliverChildBuilderDelegate(

                      (context, index) {
                        return _rules(context, widget.event.rules[_timerIndex].keys.toList()[index], Icon(Icons.calendar_view_week), _timerIndex);
                      },
                    childCount: widget.event.rules.isNotEmpty ? widget.event.rules[_timerIndex].length : 0
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

  Widget _daysOfWeek(BuildContext context, int time) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _checkBox(context, _weekDays[0]['name'], _weekDays[0]['isChecked'], 0, time),
          _checkBox(context, _weekDays[1]['name'], _weekDays[1]['isChecked'], 1, time),
          _checkBox(context, _weekDays[2]['name'], _weekDays[2]['isChecked'], 2, time),
          _checkBox(context, _weekDays[3]['name'], _weekDays[3]['isChecked'], 3, time),
          _checkBox(context, _weekDays[4]['name'], _weekDays[4]['isChecked'], 4, time),
          _checkBox(context, _weekDays[5]['name'], _weekDays[5]['isChecked'], 5, time),
          _checkBox(context, _weekDays[6]['name'], _weekDays[6]['isChecked'], 6, time),
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
                      border: Border.all(color: _yearOperatorStates[index] ? Colors.orange : Colors.black), /// ToDo: farbliche kennzeichnung ist heir nur in einer liste
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              _changeOperator(index, widget.event.rules[_timerIndex]['Year']!);
                              _yearOperatorStates = _operatorSelection(widget.event.rules[_timerIndex]['Year']!['operator']);
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
                    _countDownYear(widget.event.rules[_timerIndex]['Year']!);
                  });
                },
                icon: Icon(
                    Icons.arrow_back_ios,
                  color: Colors.white,
                )
            ),
            Text(
              widget.event.rules[_timerIndex]['Year']!['yearNo'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    _countUpYear(widget.event.rules[_timerIndex]['Year']!);
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


  Widget _rules(BuildContext context, String name, Icon icon, int time) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Stack(
        children: [
          _edit ? Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
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
                    overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.3)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                    ))
                ),
                onPressed: () {
                  setState(() {
                    widget.event.rules[_timerIndex].remove(name);
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                )
            ),
          ) : Container(),
          Container(
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
                    _daysOfWeek(context, time),
                  if (name == 'Year')
                    /// <Rule xsi:type="Year" allow="true" yearNo="2024" operator="&lt;=" />
                    _year(context)
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _checkBox(BuildContext context, String weekDay, bool state, int day, int time) {
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
                _changeDaysOfWeek(widget.event.rules[_timerIndex]['DaysOfWeek']!, !state, weekDay);
              });
            }
        )
      ],
    );
  }

  Widget _conditionSettings(BuildContext context) {
    return Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         child: ListView.builder(
              itemCount: 2,
             itemBuilder: (context, index) {
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
                          _conditions[index],
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      trailing: Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.blue),
                        checkColor: Colors.blue,
                        shape: CircleBorder(),
                        key: Key(_conditions[index]),
                        value: _conditionsState[_conditions[index]] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _conditionsState[_conditions[index]] = value!;
                          });
                        },
                      ),
                      children: [
                        Container(
                          height: 200,
                          child: Text(
                            'Lorem ipsum'
                          ),
                        )
                      ],

                    ),
                  ),
                );
             }
         ),
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


