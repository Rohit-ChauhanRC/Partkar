class Constants {
  static const BASE_URL = 'https://partaker.net/';
  // static const BASE_URL = 'https://admin.agapecca.org/';

  static const END_POINT_CLUBS = 'api/v1/clubs';
  static const END_POINT_CLUB_INFO = 'api/v1/clubs-info';
  static const END_POINT_VERSION_CHECK = 'api/v1/app-version';
  static const END_POINT_REGISTER = 'api/v1/signup';
  static const END_POINT_LOGIN = 'api/v1/login';
  static const END_POINT_SOCIAL_LOGIN = 'api/v1/social-login';
  static const END_POINT_FORGOT_PASSWORD = 'api/v1/forgot-password';
  static const END_POINT_CHANGE_PASSWORD = 'api/v1/change-password';
  static const END_POINT_LOGOUT = 'api/v1/logout';
  static const END_POINT_UPDATE_DEVICE_DETAILS = 'api/v1/update-details';
  static const END_POINT_APP_POLICY = 'api/v1/app-policy';
  static const END_POINT_PROFILE = 'api/v1/profile';
  static const END_POINT_PROFILE_UPDATE = 'api/v1/update-profile';
  static const END_POINT_HOME = 'api/v1/home';
  static const END_POINT_BIBLE = 'api/v1/bible';
  static const END_POINT_BIBLE_CHAPTER_DETAILS = 'api/v1/chapter';
  static const END_POINT_BIBLE_SETTINGS = 'api/v1/bible-settings';
  static const END_POINT_BIBLE_READING_SCHEDULE =
      'api/v1/bible-reading-schedule';
  static const END_POINT_BIBLE_READING = 'api/v1/bible-reading';
  static const END_POINT_BIBLE_READ_TRACKING = 'api/v1/bible-tracking';
  static const END_POINT_SONGS_LIST = 'api/v1/songs';
  //ignore: non_constant_identifier_names
  static String END_POINT_SONG_DETAIL(String id) {
    return 'api/v1/song/$id';
  }

  static const END_POINT_DISCIPLISHIP_LIBRARIES =
      'api/v1/discipleship-libraries';
  //ignore: non_constant_identifier_names
  static String END_POINT_DISCIPLISHIP_LIBRARY(String id) {
    return 'api/v1/discipleship-library/$id';
  }

  static const END_POINT_PODCASTS_LIBRARIES = 'api/v1/podcast-libraries';
  //ignore: non_constant_identifier_names
  static String END_POINT_PODCAST_LIBRARY(String id) {
    return 'api/v1/discipleship-library/$id';
  }

  static const END_POINT_MEETINGS = 'api/v1/meetings';
  static const END_POINT_EVENTS = 'api/v1/events';
  //ignore: non_constant_identifier_names
  static String END_POINT_EVENT_DETAILS(String id, String clubId, String mode) {
    return 'api/v1/event/$id?club_id=$clubId&mode=$mode';
  }

  // static const END_POINT_KNOW_US = 'api/v1/get-to-know-us';//get-to-know-us?club_id=8&mode=night
  //ignore: non_constant_identifier_names
  static String END_POINT_KNOW_US(String clubId, String mode) {
    return 'api/v1/get-to-know-us?club_id=$clubId&mode=$mode';
  }

  static const END_POINT_SOCIAL_MEDIA = 'api/v1/social-media';
  static const END_POINT_NOTIFICATION_SETTINGS = 'api/v1/notification-settings';
  static const END_POINT_NOTIFICATIONS = 'api/v1/notifications';
//ignore: non_constant_identifier_names
  static String END_POINT_NOTIFICATION_DETAIL(
      String id, String clubId, String mode) {
    return 'api/v1/notification-info/$id?club_id=$clubId&mode=$mode';
  }

  static const END_POINT_SHARE_DETAILS = 'api/v1/club-details';

  //
  //
  //FONT FAMILIES
  static const FONT_FAMILY_FUTURA = 'Futura';
  //static const FONT_FAMILY_TIMES = 'Times';
  static const FONT_FAMILY_TIMES = 'Futura';
}




/**
 * 
 * event/{id}?club_id=8&mode=day
 * 
 * 
1) api/v1/discipleship-libraries

METHOD :- GET

2) api/v1/discipleship-library/1

Method :- GET
Note : in web url add (&mode=day/night)
 * 
 */