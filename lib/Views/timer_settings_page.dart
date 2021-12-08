import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lcn/Models/models.dart';

class TimerSettingsPage extends StatefulWidget {
  const TimerSettingsPage({Key? key, required this.event, required this.name}) : super(key: key);

  final Event event;
  final String name;

  @override
  _TimerSettingsPageState createState() => _TimerSettingsPageState();
}

class _TimerSettingsPageState extends State<TimerSettingsPage> {

  late TextEditingController _controllerName;
  late TextEditingController _controllerTime;

  @override
  void initState() {
    _controllerName = TextEditingController();
    _controllerTime = TextEditingController();
    _controllerName.text = widget.name;
    _controllerTime.text = widget.event.times[0];
    //print(widget.times);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Column(
          children: [
            _timerSettings(context, identifier: 'Name', controller: _controllerName),
            _timerSettings(context, identifier: 'Zeit', controller: _controllerTime),
            _header(context),
            Expanded(
              child: ListView.builder(
                itemCount: widget.event.rules[0].length,
                  itemBuilder: (context, index) {
                  print(widget.event.rules[0]);
                  //return Container();
                  return _rules(context, widget.event.rules[0][index].first.value, Icon(Icons.calendar_view_week));
                  }),
            )

          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
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
            child: Text('Bedingungen',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18.0
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
        child: TextButton(
          onPressed: () {
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
            trailing: Icon(Icons.workspaces_filled, color: Colors.amber,),
          ),
        ),
      ),
    );
  }

}
