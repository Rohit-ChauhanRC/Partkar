import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/error_response.dart';
import '../modals/app_policy_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
// import '../utilities/Helper.dart';
import '../widgets/spacer.dart';
import '../bloc/app_policy_provider.dart';
import '../bloc/general_provider.dart';
import 'navigation_drawer.dart';

class AboutAppScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
      //bottomNavigationBar: Helper.NAVIGATION_BAR,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        'About the app',
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

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(BuildContext context) {
    AppPolicyBloc appPolicyBloc = AppPolicyProvider.of(context);
    return FutureBuilder(
      future: appPolicyBloc.fetchpolicies(),
      builder: (cntxt, snapshot) {
        if (!(snapshot.hasData)) {
          // if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is PoliciesModal) {
            return _viewBuilder(context, data.policies);
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }

  Widget _viewBuilder(BuildContext context, List<PolicyModal> policies) {
    // print('policies');
    // print(policies);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space(verticle: 20),
          _aboutApp(context),
          ..._policies(context, policies),
        ],
      ),
    );
  }

  Widget _aboutApp(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _icon(context),
        Expanded(child: _appInfo()),
      ],
    );
  }

  Widget _icon(BuildContext context) {
    double iconWidth = MediaQuery.of(context).size.width * 0.25;
    return Image.asset(
      'assets/images/LOGO.png',
      width: iconWidth,
      height: iconWidth,
    );
  }

  Widget _appInfo() {
    String url =
        'https://GetPartaker.com/'; //Constants.BASE_URL; //'https://agapecca.org';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space(verticle: 10),
        Text(
          'Partaker Christian Clubs App',
          style: TextStyle(
            color: colours.headlineColour(),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Space(verticle: 5),
        Text(
          '© 2021 Centennial Software Inc.',
          style: TextStyle(
            color: colours.bodyTextColour(),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 15,
          ),
        ),
        Text(
          'All Rights Reserved.',
          style: TextStyle(
            color: colours.bodyTextColour(),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 13,
          ),
        ),
        GestureDetector(
          child: Text(
            url,
            style: TextStyle(
              color: colours.headlineColour(),
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            if (await canLaunch(url)) {
              launch(url);
            }
          },
        ),
        Space(verticle: 5),
        _appVersion(),
      ],
    );
  }

  Widget _appVersion() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          return Text(
            'App version: ${snapshot.data.version}',
            style: TextStyle(
              color: colours.bodyTextColour(),
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> _policies(BuildContext context, List<PolicyModal> policies) {
    List<Widget> widgets = [];
    for (int i = 0; i < policies.length; i++) {
      widgets.add(Space(verticle: 20));
      widgets.add(_policyOption(context, policies[i]));
    }
    return widgets;
  }

  Widget _policyOption(BuildContext context, PolicyModal policy) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: GestureDetector(
        child: Text(
          policy.type,
          style: TextStyle(
            color: colours.bodyTextColour(),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          _popup(context, policy);
        },
      ),
    );
  }

  void _popup(BuildContext context, PolicyModal policy) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: colours.bgColour(),
          content: Container(
            height: size.height * 0.8,
            width: size.width,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            margin: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(policy.type),
                Space(verticle: 20),
                _description(policy.description),
                Space(verticle: 20),
                _cancelButton(cntxt),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colours.headlineColour(),
      ),
    );
  }

  Widget _description(String description) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          '${description.replaceAll('\\n', '\n').replaceAll('\\r', '\r')}',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 14,
            color: colours.bodyTextColour(),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _close(context);
        },
        child: Text(
          'OK',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            color: colours.headlineColour(),
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
