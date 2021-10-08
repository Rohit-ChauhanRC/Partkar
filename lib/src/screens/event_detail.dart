import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/event_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/event_responses.dart';
import 'navigation_drawer.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  EventDetailScreen({@required this.eventId});

  @override
  State<EventDetailScreen> createState() {
    return _EventDetailScreenState(eventId: eventId);
  }
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final String eventId;
  WebViewController _controller;

  _EventDetailScreenState({@required this.eventId});

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
        'Event Detail',
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
    EventBloc eventBloc = EventProvider.of(context);
    //return Text('Event Details');
    String mode = Setting().mode() == ColourModes.day ? 'day' : 'night';
    return FutureBuilder(
      future: eventBloc.fetchEventDetail(eventId, mode),
      builder: (settingContext, snapshot) {
        if (!(snapshot.hasData)) {
          // if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is EventDetailInfoModal) {
            return WebView(
              initialUrl: 'about:blank',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _loadHtml(data.longDescription);
              },
            );
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }

  _loadHtml(String htmlText) async {
    _controller.loadUrl(Uri.dataFromString(htmlText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
