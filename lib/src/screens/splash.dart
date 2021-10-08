import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'club_selector.dart';
import '../bloc/login_provider.dart';
import '../bloc/club_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../resources/data_store.dart';
import '../utilities/settings.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _splashBuilder(context),
    );
  }

  Widget _splashBuilder(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      _processSettings(context);
    });
    double height = MediaQuery.of(context).size.width;
    return Center(
      child: Image.asset(
        'assets/images/_SPLASH.png',
        height: height,
        width: height,
        alignment: Alignment.center,
      ),
    );
  }

  void _processSettings(BuildContext context) async {
    // print('_1');
    final isUserLoggedIn = await DataStore().isUserLoggedIn();
    // print('_2');
    await Setting().loadColourMode();
    // print('_3');
    await Setting().loadColours();
    // print('_4');
    //print(await DataStore().getLoginToken());
    if (isUserLoggedIn) {
      // print('_5');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (cntxt) => PodcastProvider(
                  child: GeneralProvider(
                      child: NotificationProvider(child: HomeScreen())))));
    } else {
      // print('_6');
      final mediaUrl = await DataStore().getClubMediaUrl();
      // print('_7');
      final club = await DataStore().getSelectedClub();
      // print('_8');

      if ((mediaUrl != null) && (club != null)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (cntxt) => LoginProvider(
                    child: ClubProvider(
                        child: LoginScreen(mediaUrl: mediaUrl, club: club)))));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (cntxt) =>
                    ClubProvider(child: ClubSelectorScreen(fromSplash: true))));
      }
    }
  }
}
