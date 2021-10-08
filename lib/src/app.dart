import 'package:flutter/material.dart';
import 'screens/splash.dart';
import '../src/utilities/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _appBuilder();
  }

  Widget _appBuilder() {
    print('Building app');
    return MaterialApp(
      title: 'Partaker',
      theme: ThemeData(
        primaryColor: Color(0xff093454),
        fontFamily: Constants.FONT_FAMILY_FUTURA,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
