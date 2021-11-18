import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class StatusPage extends ConsumerStatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends ConsumerState<StatusPage> {
  @override
  Widget build(BuildContext context) {
    final futureGetStatus = ref.watch(futureGetStatusProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Status',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: futureGetStatus.when(
            data: (data) => Container(
              child: Column(
                children: [
                  Text(
                      'Verbindungsstatus',
              //'${data.data['d']}',
                      style: TextStyle(
                        color: Colors.amber
                      ),
                  ),
                  Row(
                    children: [
                      data.data['d']['IsLcnServerConnected'] ? Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.cancel, color: Colors.red,),
                      Text(data.data['d']['LcnBusConnectionStates'][0]['BusName'], style: TextStyle(color: Colors.white),)
                    ],
                  )
                ],
              ),
              //child: Text('${data.data['d']}'),
            ),
            error: (e, st) => Container(child: Text(e.toString()),),
            loading: () => CircularProgressIndicator()),
      ),
    );
  }
}
