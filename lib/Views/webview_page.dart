import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends ConsumerStatefulWidget {
  const WebViewPage({Key? key,required this.title,required this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {

  late WebViewController _webViewController;
  late dioCookieManager.CookieManager _cookieManager;
  late var _cManager;

  @override
  void initState() {
    //dio = ref.watch(dioProvider);
    //_cookieManager = _dio.interceptors.first;


    print(widget.url);
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }


  @override
  Widget build(BuildContext context) {
    Dio _dio = ref.watch(dioProvider);
    _cManager = _dio.interceptors.first;
    print(_dio.interceptors.toList()[0]);
    _cookieManager = _cManager;
    //print(_cookieManager.cookieJar.loadForRequest(uri));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(widget.title),
        ),
        body: Column(children: [
          Expanded(
              child: WebView(
                  initialUrl: '',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    webViewController.loadUrl(Uri.encodeFull(widget.url),);
                  },
              )
          )
        ])
    );
  }
}
