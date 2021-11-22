import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';


class TableauService extends StateNotifier<Dio> {

  TableauService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Tableau1.asmx/";

  //final Dio _dio = Dio();

  Future<List> getTableaus() async {
    List _tableauList = [];
    String serviceMethod = "GetTableaus";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', })
    );
    print('drin');
    Map resMap = res.data;
    print(resMap);
    List _listOfItems = resMap['d']['Items'];
    _listOfItems.forEach((element) {
      if (element['Tableaus'].isNotEmpty) {
        _tableauList.add({'${element['Name']}': element['Tableaus']});
      }
    });
    print(_tableauList);
    return _tableauList;
  }

  Future openTableaus() async {
    return;
  }

  Future closeTableaus() async {
    return;
  }


}