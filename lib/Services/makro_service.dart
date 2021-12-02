import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class MakroService extends StateNotifier<Dio> {

  MakroService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/MacroServer1.asmx/";

  Future<List> getMacros() async {
    String serviceMethod = "GetMacros";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', })
    );

    Map resMap = res.data;
    print(resMap['d']['Items']);
    return resMap['d']['Items'];
  }
}