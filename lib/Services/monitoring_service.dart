import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';

class MonitoringService extends StateNotifier<Dio> {

  MonitoringService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/MonitoringServer1.asmx/";

  Future<List> getMonitoringEvents() async {
    String serviceMethod = "GetMonitoringEvents";
    Dio _dio = ref.watch(dioProvider);

    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', })
    );



    print('djghkjdhgkdhgk');
    Map resMap = res.data;
    print(resMap['d']['Items']);

    return resMap['d']['Items'];
  }


  Future<Response> getMonitoringActions() async {
    String serviceMethod = "GetMonitoringActions";
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