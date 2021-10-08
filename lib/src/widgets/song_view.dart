import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';

class SongView extends StatefulWidget {
  final String htmlString;

  SongView({@required this.htmlString});

  @override
  State createState() {
    return _SongViewState(htmlText: htmlString);
  }
}

class _SongViewState extends State<SongView> {
  // WebViewController _controller;
  final String htmlText;

  _SongViewState({@required this.htmlText});

  @override
  Widget build(BuildContext context) {
    return _uiBuilder(context);
  }

  Widget _uiBuilder(BuildContext context) {
    return Text('No');
    // return WebView(
    //   initialUrl: 'about:blank',

    //   onWebViewCreated: (WebViewController webViewController) {
    //     _controller = webViewController;
    //     _loadHtml();
    //   },
    // );
  }

  // _loadHtml() async {

  //   _controller.loadUrl(Uri.dataFromString(htmlText,
  //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }
}
