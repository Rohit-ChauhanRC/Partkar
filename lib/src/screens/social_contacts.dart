import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/know_us_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/know_us_responses.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
import 'navigation_drawer.dart';

class SocialContactsScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final String title;
  final KnowUsBloc bloc;

  SocialContactsScreen({@required this.title, @required this.bloc});

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
        title,
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
    return FutureBuilder(
      future: bloc.fetchSocialLinks(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
          } else if (data is SocialMediaModal) {
            return _linkList(context, data);
          }
          return Container();
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
  }

  Widget _linkList(BuildContext context, SocialMediaModal mediaData) {
    return ListView.separated(
      itemBuilder: (cntxt, index) {
        return GestureDetector(
          child: _listItem(mediaData.socialMedia[index], mediaData.mediaUrl),
          onTap: () {
            _listItemSelected(context, mediaData.socialMedia[index]);
          },
        );
      },
      separatorBuilder: (cntxt, index) {
        return Divider(height: 2, color: Colors.grey);
      },
      itemCount: mediaData.socialMedia.length,
    );
  }

  Widget _listItem(SocialLinkModal socialLink, String mediaUrl) {
    String iconUrl = mediaUrl + socialLink.image;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _listImage(iconUrl),
          Space(horizontal: 10),
          Expanded(child: _listInfo(socialLink)),
        ],
      ),
    );
  }

  Widget _listImage(String imageUrl) {
    return Container(
      //padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: _imageDecoration(),
      child: Center(
        child: SizedBox(
          width: 120,
          height: 70,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  BoxDecoration _imageDecoration() {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(2)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[400],
          blurRadius: 8,
        ),
      ],
    );
  }

  Widget _listInfo(SocialLinkModal socialLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 0),
        _title(socialLink.title),
        Space(verticle: 2),
        _description(socialLink.username),
        Space(verticle: 10),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _description(String text) {
    return Text(
      text,
      style: TextStyle(
        color: colours.bodyTextColour().withOpacity(0.8),
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 14,
      ),
    );
  }

  void _listItemSelected(
      BuildContext context, SocialLinkModal socialLink) async {
    String appURL = socialLink.appURL;
    String url = socialLink.url;
    if (await canLaunch(appURL)) {
      launch(appURL);
    } else if (await canLaunch(url)) {
      launch(url);
    } else {
      print('Unable to launch');
    }
  }
}
