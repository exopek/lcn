import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class MakroPage extends ConsumerStatefulWidget {
  const MakroPage({Key? key}) : super(key: key);

  @override
  _MakroPageState createState() => _MakroPageState();
}

class _MakroPageState extends ConsumerState<MakroPage> {
  @override
  Widget build(BuildContext context) {
    final futureGetMakro = ref.watch(futureGetMakroProvider);
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
                  return _listContent(context, data[index]['Name']);
                }),
            error: (e, st) => Container(child: Text(e.toString()),),
            loading: () => CircularProgressIndicator()),
      ),
    );
  }


  Widget _listContent(BuildContext context, String name) {
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
      ),
    );
  }
}
