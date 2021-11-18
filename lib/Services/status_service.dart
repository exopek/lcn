import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class StatusService extends StateNotifier<Dio> {

  StatusService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Status1.asmx/";

  Future<Response> getStatus() async {
    String serviceMethod = "GetStatus";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', })
    );

    Map resMap = res.data;
    print(resMap);
    return res;
  }
}