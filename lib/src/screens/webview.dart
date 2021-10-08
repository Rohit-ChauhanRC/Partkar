import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/general_provider.dart';
import 'navigation_drawer.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  final String htmlData;

  WebViewScreen({@required this.title, this.url, this.htmlData});

  @override
  State<WebViewScreen> createState() {
    return _WebViewScreenState(title: title, url: url, htmlData: htmlData);
  }
}

class _WebViewScreenState extends State<WebViewScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final String title;
  final String url;
  final String htmlData;
  WebViewController _controller;

  _WebViewScreenState({@required this.title, this.url, this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(BuildContext context) {
    // print(url);
    // print(htmlData);
    if ((url != null) && (url != '')) {
      return _fromUrl();
    } else if ((htmlData != null) && (htmlData != '')) {
      return _fromHtmlData();
    } else {
      return Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 22,
          ),
        ),
      );
    }
  }

  Widget _fromUrl() {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  Widget _fromHtmlData() {
    return WebView(
      initialUrl: '',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        _loadHtml(htmlData);
      },
    );
  }

  _loadHtml(String htmlText) async {
    String html = _processedHtlm(htmlText);
    // print('THIS is processed  html to process');
    // print(html);
    _controller.loadUrl(Uri.dataFromString(htmlText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  String _processedHtlm(String givenHtml) {
    // print('THIS is html to process');
    // print(givenHtml);
    return givenHtml
        .replaceAll('--textColor--', colours.bodyTextColor)
        .replaceAll('--bgColor--', colours.bgColor)
        .replaceAll('--accentColor--', colours.accentColor)
        .replaceAll('--headlineColor--', colours.headlineColor)
        .replaceAll('--gradientStartColor--', colours.gradientEndColor)
        .replaceAll('--gradientEndColor--', colours.gradientStartColor);
  }
}
