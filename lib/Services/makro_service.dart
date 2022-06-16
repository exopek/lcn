import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';

class MakroService extends StateNotifier<Dio> {

  MakroService(this.ref) : super(Dio());

  final Ref ref;
  /// ToDo: Muss Variable sein
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/MacroServer1.asmx/";

  Future<List<Macro>> getMacros() async {
    String serviceMethod = "GetMacros";
    List<Macro> macroList = [];
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', })
    );
    if (res.statusCode == 200) {
      Map resMap = res.data;
      /// element sind hier Listenelemente vom Typ Map
      resMap['d']['Items'].forEach((element) {
        macroList.add(Macro.fromMap(element));
      });

    } else {
      throw(Exception('Request to get Macros failed'));
    }

    return macroList;
  }

  Future<bool> executeMacro({required String macroName}) async {
    String serviceMethod = "ExecuteMacro";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', }),
        data: {'macroName': macroName}
    );
    if (res.statusCode == 200) {
      print(res.data);
      return res.data['d'];
    } else {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    String serviceMethod = "IsEnabled";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', }),
    );
    return res.data;
  }

  Future<void> setEnabled({required String enabled}) async {
    String serviceMethod = "SetEnabled";
    Dio _dio = ref.watch(dioProvider);
    await _dio.post(
      basicUrl+serviceMethod,
      options: Options(headers: {'Content-Type': 'application/json', }),
      data: enabled
    );
  }
}