import 'package:flutter/material.dart';
import '../modals/club_responses.dart';
import '../widgets/spacer.dart';
import '../utilities/constants.dart';

class ClubItemWidget extends StatelessWidget {
  final ClubModal club;
  final String mediaUrl;

  ClubItemWidget({@required this.club, @required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return _clubListItem();
  }

  Widget _clubListItem() {
    String clubLogo = '';
    if ((club.clubLogo != null) && (club.clubLogo != '')) {
      clubLogo = mediaUrl + club.clubLogo;
    }
    return Container(
      //height: 80,
      margin: EdgeInsets.all(10),
      decoration: _clubListItemDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _clubImage(clubLogo),
          Space(horizontal: 5),
          Expanded(child: _clubInfo()),
        ],
      ),
    );
  }

  BoxDecoration _clubListItemDecoration() {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 8,
        ),
      ],
    );
  }

  Widget _clubImage(String imageUrl) {
    Image logo;
    if (imageUrl == '') {
      logo = Image.asset(
        'assets/images/LOGO.png',
        alignment: Alignment.center,
        fit: BoxFit.cover,
      );
    } else {
      logo = Image.network(
        imageUrl,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      );
    }
    return Container(
      padding: EdgeInsets.all(5),
      child: Center(
        child: SizedBox(
          width: 70,
          height: 70,
          child: logo,
        ),
      ),
    );
  }

  Widget _clubInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Space(verticle: 5),
        _name(club.clubName),
        Space(verticle: 2),
        _stateCity('${club.city}, ${club.state}'),
        Space(verticle: 5),
      ],
    );
  }

  Widget _name(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
      ),
    );
  }

  Widget _stateCity(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[800],
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 14,
      ),
    );
  }
}
