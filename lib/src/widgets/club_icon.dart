import 'package:flutter/material.dart';
import '../resources/data_store.dart';
import '../utilities/settings.dart';

class ClubIconWidget extends StatelessWidget {
  final ColourModes colourMode;

  ClubIconWidget({@required this.colourMode});

  @override
  Widget build(BuildContext context) {
    return _uiBuilder();
  }

//final mediaUrl = await DataStore().getClubMediaUrl();
  Widget _uiBuilder() {
    return FutureBuilder(
      future: DataStore().getClubMediaUrl(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          var mediaUrl = snapshot.data;
          return _club(mediaUrl);
        }
        return _club('');
      },
    );
  }

  Widget _club(String mediaUrl) {
    return FutureBuilder(
      future: DataStore().getSelectedClub(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          var club = snapshot.data;
          String clubLogo = '';
          if (colourMode == ColourModes.day) {
            clubLogo = club.clubLogo ?? '';
          } else if (colourMode == ColourModes.night) {
            clubLogo = club.clubLogoNightMode ?? '';
          }
          if ((clubLogo != null) && (clubLogo != '')) {
            clubLogo = mediaUrl + club.clubLogo;
          }
          return _clubImage(clubLogo);
        }
        return _clubImage('');
      },
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
      padding: EdgeInsets.all(0),
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: logo,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
