import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

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
          'Makros',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: futureGetTimer.when(
            data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _listContent(context, data[index]['Description'], data[index]['Times'][0]['TimeOfInvocationString']);
                }),
            error: (e, st) => Container(child: Text(e.toString()),),
            loading: () => CircularProgressIndicator()),
      ),
    );
  }


  Widget _listContent(BuildContext context, String name, String time) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.amber)
      ),
      onPressed: () {
      },
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0
          ),
        ),
      ),
    );
  }
}
