import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../modals/user_responses.dart';
import '../modals/club_responses.dart';
import '../utilities/settings.dart';

enum UserType { none, root, org, teacher, student }

class DataStore {
  static final DataStore _instance = new DataStore._internal();

  factory DataStore() {
    return _instance;
  }

  DataStore._internal();

  final String _keyTemp = 'tempfcm';
  final String _keyFcmToken = 'fcm';
  final String _keyLoginToken = 'key_login_token';
  final String _keyUser = 'key_user';
  final String _keyUserLoginClub = 'key_user_login_club';
  final String _keyUserLoginClubColours = 'key_user_login_club_colour';
  final String _keySelectedColourMode = 'key_selected_colourM_mode';
  final String _keySelectedClub = 'key_selected_club';
  final String _keyClubMediaUrl = 'key_Club_media_url';
  final String _keyRememberMeMail = 'key_remember_me_mail';
  final String _keyMobileDataVideoPodcast = 'key_mobile_data_video_podcast';
  final String _keyMobileDataAudioPodcast = 'key_mobile_data_audio_podcast';
  final String _keySongToggleState = 'key_song_toggle_state';
  final String _keyHiddenNotifications = 'key_hidden_notifications';

  //Check if logged in
  Future<bool> isUserLoggedIn() async {
    // print('=1');
    final prefs = await SharedPreferences.getInstance();
    // print('=2');
    final tokenString = prefs.getString(_keyLoginToken);
    // print('=3');
    return (tokenString != null);
  }

  //
  //hide notifications id
  Future<void> hideNotification(int id) async {
    List<String> hiddenIds = await hiddenNotificationIds();
    final prefs = await SharedPreferences.getInstance();
    if ((hiddenIds == null) || (hiddenIds.length == 0)) {
      prefs.setStringList(_keyHiddenNotifications, [id.toString()]);
    } else {
      hiddenIds.add(id.toString());
      prefs.setStringList(_keyHiddenNotifications, hiddenIds);
    }
  }

  Future<List<String>> hiddenNotificationIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_keyHiddenNotifications);
    // print(ids);
    return ids;
  }

  Future<bool> isNotificationHidden(int id) async {
    final List<String> hiddenIds = await hiddenNotificationIds();
    return hiddenIds.contains(id.toString());
  }

  Future<void> removeHiddenNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keySelectedClub);
  }

  //
  //Selected club
  Future<void> saveSelectedClub(ClubModal club) async {
    final clubStr = jsonEncode(club.toMap());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keySelectedClub, clubStr);
  }

  Future<ClubModal> getSelectedClub() async {
    final prefs = await SharedPreferences.getInstance();
    final clubStr = prefs.getString(_keySelectedClub);
    if (clubStr == null) {
      return null;
    }
    ClubModal root = ClubModal.fromJSON(json.decode(clubStr));
    return root;
  }

  Future<void> removeSelectedClub() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keySelectedClub);
  }

  //
  //Club media url
  Future<void> saveClubMediaUrl(String mediaUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyClubMediaUrl, mediaUrl);
  }

  Future<String> getClubMediaUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final mediaUrl = prefs.getString(_keyClubMediaUrl);
    return mediaUrl;
  }

  Future<void> removeClubMediaUrl() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyClubMediaUrl);
  }

  //
  //Remember me email
  Future<void> saveRememberMeEmail(String mail) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyRememberMeMail, mail);
  }

  Future<String> getRememberMeMail() async {
    final prefs = await SharedPreferences.getInstance();
    final mail = prefs.getString(_keyRememberMeMail);
    return mail;
  }

  Future<void> removeRememberMeMail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyRememberMeMail);
  }

  //
  //FCM token
  Future<void> saveFcmToken(String tokenString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyFcmToken, tokenString);
  }

  Future<String> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString(_keyFcmToken);
    return tokenString ?? '';
  }

  Future<void> removeFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyFcmToken);
  }

  //
  //Login token
  Future<void> saveLoginToken(String tokenString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyLoginToken, tokenString);
  }

  Future<String> getLoginToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString(_keyLoginToken);
    return 'Bearer $tokenString';
  }

  Future<void> removeLoginToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyLoginToken);
  }

  //
  // User

  Future<void> saveUser(UserModal org) async {
    final rootStr = jsonEncode(org.toMap());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUser, rootStr);
  }

  Future<UserModal> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rootStr = prefs.getString(_keyUser);
    if (rootStr == null) {
      return null;
    }
    UserModal root = UserModal.fromJSON(json.decode(rootStr));
    return root;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
  }

  //
  // User Login club

  Future<void> saveLoginClub(ClubModal club) async {
    final clubStr = jsonEncode(club.toMap());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUserLoginClub, clubStr);
  }

  Future<ClubModal> getLoginClub() async {
    final prefs = await SharedPreferences.getInstance();
    final clubStr = prefs.getString(_keyUserLoginClub);
    if (clubStr == null) {
      return null;
    }
    ClubModal club = ClubModal.fromJSON(json.decode(clubStr));
    return club;
  }

  Future<void> removeLoginClub() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUserLoginClub);
  }

  //
  // User Login club colours

  Future<void> saveLoginClubColours(ClubColourModesModal colours) async {
    final coloursStr = jsonEncode(colours.toMap());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUserLoginClubColours, coloursStr);
  }

  Future<ClubColourModesModal> getLoginClubColours() async {
    final prefs = await SharedPreferences.getInstance();
    final coloursStr = prefs.getString(_keyUserLoginClubColours);
    if (coloursStr == null) {
      return null;
    }
    ClubColourModesModal root =
        ClubColourModesModal.fromJSON(json.decode(coloursStr));
    return root;
  }

  Future<void> removeLoginClubColours() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUserLoginClubColours);
  }

  //
  // User Login club colours

  Future<void> saveSelectedColourMode(ColourModes mode) async {
    final modeStr = mode.toString();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keySelectedColourMode, modeStr);
    await Setting().loadColourMode();
  }

  Future<ColourModes> getSelectedColourMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keySelectedColourMode);
    if (modeStr == null) {
      return ColourModes.day;
    }
    ColourModes mode =
        ColourModes.values.firstWhere((e) => e.toString() == modeStr);
    return mode;
  }

  Future<void> removeSelectedColourMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keySelectedColourMode);
  }

  //
  //Use mobile data for audio podcast
  Future<void> saveMobileDataStatusForAudioPodcasts(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyMobileDataAudioPodcast, status);
  }

  Future<bool> getMobileDataStatusForAudioPodcasts() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool(_keyMobileDataAudioPodcast);
    return status ?? true;
  }

  Future<void> removeMobileDataStatusForAudioPodcasts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyMobileDataAudioPodcast);
  }

  //
  //use mobile data for video podcast
  Future<void> saveMobileDataStatusForVideoPodcasts(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyMobileDataVideoPodcast, status);
  }

  Future<bool> getMobileDataStatusForVideoPodcasts() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool(_keyMobileDataVideoPodcast);
    return status;
  }

  Future<void> removeMobileDataStatusForVideoPodcasts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyMobileDataVideoPodcast);
  }

  //
  //temp data
  Future<void> saveTemp(String tokenString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyTemp, tokenString);
  }

  Future<String> getTemp() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString(_keyTemp);
    return tokenString ?? '';
  }

  Future<void> removeTemp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyTemp);
  }

  //
  //Club media url
  Future<void> saveSongTogleState(bool toggleState) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keySongToggleState, toggleState);
  }

  Future<bool> getSongToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    final toggleState = prefs.getBool(_keySongToggleState);
    return toggleState;
  }

  Future<void> removeSongToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keySongToggleState);
  }

  //
  //

  void removeAllData() {
    removeLoginToken();
    removeUser();
  }
}
