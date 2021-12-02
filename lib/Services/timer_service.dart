import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class TimerService extends StateNotifier<Dio> {

  TimerService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Timer1.asmx/";

  Future<List> getTimerEvents() async {
    String serviceMethod = "GetTimerEvents";
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