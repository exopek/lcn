import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Services/auth_service.dart';
import 'package:lcn/Services/makro_service.dart';
import 'package:lcn/Services/monitoring_service.dart';
import 'package:lcn/Services/status_service.dart';
import 'package:lcn/Services/tableau_service.dart';
import 'package:lcn/Services/timer_service.dart';

final dioProvider = Provider((ref) {
  Dio dio = Dio();
  return dio;
});

final dioTableauProvider = Provider<TableauService>((ref) {
  return TableauService(ref);
});

final dioAuthProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

final dioTimerProvider = Provider<TimerService>((ref) {
  return TimerService(ref);
});

final futureGetTableausProvider = FutureProvider<List>((ref) {
  return TableauService(ref).getTableaus();
});

final futureGetStatusProvider = FutureProvider<Response>((ref) {
  return StatusService(ref).getStatus();
});

final futureLogoutProvider = FutureProvider<Response>((ref) {
  return AuthService(ref).logout();
});

final futureGetMakroProvider = FutureProvider<List>((ref) {
  return MakroService(ref).getMacros();
});

final futureGetTimerProvider = FutureProvider<List>((ref) {
  return TimerService(ref).getTimerEvents();
});

final futureGetMonitoringEventsProvider = FutureProvider<List>((ref) {
  return MonitoringService(ref).getMonitoringEvents();
});

final futureGetMonitoringActionsProvider = FutureProvider<Response>((ref) {
  return MonitoringService(ref).getMonitoringActions();
});
/*
final futureGetUserCostumDataProvider = FutureProvider<Response>((ref) {
  return AuthService(ref).getUserCustomData();
});

 */