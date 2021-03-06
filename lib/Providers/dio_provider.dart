import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Services/auth_service.dart';
import 'package:lcn/Services/status_service.dart';
import 'package:lcn/Services/tableau_service.dart';

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

final futureGetTableausProvider = FutureProvider<List>((ref) {
  return TableauService(ref).getTableaus();
});

final futureGetStatusProvider = FutureProvider<Response>((ref) {
  return StatusService(ref).getStatus();
});

final futureLogoutProvider = FutureProvider<Response>((ref) {
  return AuthService(ref).logout();
});

/*
final futureGetUserCostumDataProvider = FutureProvider<Response>((ref) {
  return AuthService(ref).getUserCustomData();
});

 */