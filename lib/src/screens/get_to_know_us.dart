import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/know_us_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/know_us_responses.dart';
import '../modals/error_response.dart';
import '../widgets/spacer.dart';
import 'webview.dart';
import 'social_contacts.dart';
import 'navigation_drawer.dart';

class GetToKnowUsScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        'Get to know us',
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
    KnowUsBloc knowUsBloc = KnowUsProvider.of(context);
    String mode = Setting().mode() == ColourModes.day ? 'day' : 'night';
    return FutureBuilder(
      future: knowUsBloc.fetchKnowUs(mode),
      builder: (settingContext, snapshot) {
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
          } else if (data is KnowUsModals) {
            int headerIndex = 0;
            List<KnowUsModal> knowUsData = data.getToKnowUs;
            for (int i = 0; i < knowUsData.length; i++) {
              if (knowUsData[i].type == '') {
                headerIndex = i;
                break;
              }
            }
            KnowUsModal knowUsHeader = knowUsData[headerIndex];
            knowUsData.removeAt(headerIndex);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Space(verticle: 0),
                  _knowUsHeader(context, knowUsHeader, data.mediaUrl),
                  Space(verticle: 20),
                  _gridBuilder(context, knowUsData, data.mediaUrl, knowUsBloc),
                  Space(verticle: 60),
                ],
              ),
            );
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }

  Widget _knowUsHeader(
      BuildContext context, KnowUsModal header, String mediaUrl) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      // width: size.width,
      height: size.width * 0.45,
      // padding: EdgeInsets.symmetric(horizontal: 15),
      child: Image.network(mediaUrl + header.mainImage, fit: BoxFit.cover),
    );
  }

  Widget _gridBuilder(BuildContext context, List<KnowUsModal> knowUs,
      String mediaUrl, KnowUsBloc knowUsBloc) {
    final Size size = MediaQuery.of(context).size;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      crossAxisCount: 2,
      crossAxisSpacing: size.width * 0.05,
      mainAxisSpacing: size.width * 0.05,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      children: List.generate(
        knowUs.length,
        (index) {
          return GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: colours.headlineColour(),
                child: _listItem(knowUs[index], mediaUrl, size),
              ),
            ),
            onTap: () {
              _listItemSelected(context, knowUs[index], mediaUrl, knowUsBloc);
            },
          );
        },
      ),
    );
  }

  Widget _listItem(KnowUsModal knowUs, String mediaUrl, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.width * 0.43,
          width: size.width * 0.43,
          child: Image.network(mediaUrl + knowUs.mainImage, fit: BoxFit.cover),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              knowUs.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colours.bgColour(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _listItemSelected(BuildContext context, KnowUsModal knowUs,
      String mediaUrl, KnowUsBloc knowUsBloc) {
    if ((knowUs.googleFormUrl != null) && (knowUs.googleFormUrl != '')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WebViewScreen(
                  title: knowUs.title, url: knowUs.googleFormUrl)));
    } else if (knowUs.type == 'social_media_links') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SocialContactsScreen(
                    title: knowUs.title,
                    bloc: knowUsBloc,
                  )));
    } else if ((knowUs.description != null) && (knowUs.description != '')) {
      // print(knowUs.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WebViewScreen(
                  title: knowUs.title, htmlData: knowUs.description)));
    }
  }
}
