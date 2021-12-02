import 'package:flutter/material.dart';
import 'package:lcn/Views/webview_page.dart';

class TableauPage extends StatefulWidget {
  const TableauPage({Key? key,required this.tableauElements, required this.tableauGroupName}) : super(key: key);

  final List tableauElements;
  final String tableauGroupName;

  @override
  _TableauPageState createState() => _TableauPageState();
}

class _TableauPageState extends State<TableauPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          widget.tableauGroupName,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(19, 19, 19, 1.0),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: widget.tableauElements.length,
            itemBuilder: (context, index) {
              return _tableauContent(context, widget.tableauElements[index]['TableauId']);
            }),
      ),
    );
  }

  Widget _tableauContent(BuildContext context, String name) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.amber)
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebViewPage(title: name, url: 'http://access.lcn.de/LCNGVSDemo/control.aspx?ui=$name&proj=${widget.tableauGroupName}'))
        );
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
