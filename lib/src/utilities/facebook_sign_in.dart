import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';

class PartakerFacebookSignIn {
  static Future<void> signIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    try {
      await facebookLogin.logOut();
      final result = await facebookLogin.logIn(['email', 'public_profile']);
      // print('Result --> ${result.status}');
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          //await setPrefBoolValue(is_logIn, true);
          //log user in
          result.toString();
          final fburl =
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken}';
          final graphResponse = await http.get(Uri.parse(fburl));
          final profile = json.decode(graphResponse.body);
          // print('fbresponse');
          // print(profile);

          return result.status;
          break;
        case FacebookLoginStatus.cancelledByUser:
          return null;
          break;
        case FacebookLoginStatus.error:
          return null;
        default:
          return null;
          break;
      }
    } catch (e) {
      print('Catch error in signInWithFacebook --> $e');
      return null;
    }
  }

  static Future<void> logout() async {
    FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }
}
