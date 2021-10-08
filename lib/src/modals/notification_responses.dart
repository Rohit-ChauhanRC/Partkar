class NotificationSettingsResponseModal {
  final bool status;
  final int code;
  final String message;
  final NotificationSettingsModal data;

  NotificationSettingsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = NotificationSettingsModal.fromJSON(parsedJSON['data']);
}

class NotificationSettingsModal {
  List<NotificationSettingModal> notificationSettings;

  NotificationSettingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : notificationSettings = (parsedJSON["notification_settings"] == null)
            ? null
            : (parsedJSON["notification_settings"] as List)
                .map((b) => NotificationSettingModal.fromJSON(b))
                .toList();
}

class NotificationSettingModal {
  String group;
  String title;
  String description;
  String key;
  int status;
  String havingOptions;
  List<NotificationOptionModal> options;

  NotificationSettingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : group = parsedJSON['group'],
        title = parsedJSON['title'],
        description = parsedJSON['description'],
        key = parsedJSON['key'],
        status = parsedJSON['status'],
        havingOptions = parsedJSON['havingOptions'],
        options = (parsedJSON["options"] == null)
            ? null
            : (parsedJSON["options"] as List)
                .map((b) => NotificationOptionModal.fromJSON(b))
                .toList();
}

class NotificationOptionModal {
  String title;
  String key;
  String description;
  int status;

  NotificationOptionModal.fromJSON(Map<String, dynamic> parsedJSON)
      : title = parsedJSON['title'],
        key = parsedJSON['key'],
        description = parsedJSON['description'],
        status = parsedJSON['status'];
}

//
//
//
//Notifications modal
//

class NotificationsResponseModal {
  final bool status;
  final int code;
  final String message;
  final NotificationsModal data;

  NotificationsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = NotificationsModal.fromJSON(parsedJSON['data']);
}

class NotificationsModal {
  List<NotificationModal> notifications;

  NotificationsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : notifications = (parsedJSON["notifications"] == null)
            ? null
            : (parsedJSON["notifications"] as List)
                .map((b) => NotificationModal.fromJSON(b))
                .toList();
}

class NotificationModal {
  int id;
  String title;
  String body;
  String shortDescription;
  String notificationDateTime;
  String type;

  NotificationModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        title = parsedJSON['title'],
        body = parsedJSON['body'],
        shortDescription = parsedJSON['short_description'],
        notificationDateTime = parsedJSON['notification_date_time'],
        type = parsedJSON['type'];
}

//
//
//
//Notification detail
//

class NotificationDetailResponseModal {
  final bool status;
  final int code;
  final String message;
  final NotificationDetailDataModal data;

  NotificationDetailResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = NotificationDetailDataModal.fromJSON(parsedJSON['data']);
}

class NotificationDetailDataModal {
  NotificationDetailModal notificationDetail;

  NotificationDetailDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : notificationDetail =
            NotificationDetailModal.fromJSON(parsedJSON['notification_detail']);
}

class NotificationDetailModal {
  int id;
  String availableForClub;
  String availableForGroup;
  String notificationType;
  String inAppType;
  int libraryId;
  int bibleChapterId;
  int songId;
  int eventId;
  int podcastId;
  int podcastLibraryId;
  String timezone;
  String title;
  String body;
  String notificationDate;
  String notificationTime;
  String notificationDateTime;
  String expiryDate;
  String shortDescription;
  String longDescription;
  int status;
  String isSent;
  String createdAt;
  String updatedAt;

  NotificationDetailModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        availableForClub = parsedJSON['available_for_club'],
        availableForGroup = parsedJSON['available_for_group'],
        notificationType = parsedJSON['notification_type'],
        inAppType = parsedJSON['in_app_type'],
        libraryId = parsedJSON['library_id'],
        bibleChapterId = parsedJSON['bible_chapter_id'],
        songId = parsedJSON['song_id'],
        eventId = parsedJSON['event_id'],
        podcastId = parsedJSON['podcast_id'],
        podcastLibraryId = parsedJSON['podcast_library_id'],
        timezone = parsedJSON['timezone'],
        title = parsedJSON['title'],
        body = parsedJSON['body'],
        notificationDate = parsedJSON['notification_date'],
        notificationTime = parsedJSON['notification_time'],
        notificationDateTime = parsedJSON['notification_date_time'],
        expiryDate = parsedJSON['expiry_date'],
        shortDescription = parsedJSON['short_description'],
        longDescription = parsedJSON['long_description'],
        status = parsedJSON['status'],
        isSent = parsedJSON['is_sent'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'];
}

//
//
//
//Push notification
//

class PushNotificationModal {
  int id;
  String availableForClub;
  String availableForGroup;
  String body;
  String notificationType;
  String inAppType;
  int libraryId;
  int bibleChapterId;
  int songId;
  int eventId;
  int podcastLibraryId;
  int podcastId;
  String timezone;
  String type;
  String shortDescription;
  String longDescription;

  PushNotificationModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        availableForClub = parsedJSON['available_for_club'],
        availableForGroup = parsedJSON['available_for_group'],
        body = parsedJSON['body'],
        notificationType = parsedJSON['notification_type'],
        inAppType = parsedJSON['in_app_type'],
        libraryId = parsedJSON['library_id'],
        bibleChapterId = parsedJSON['bible_chapter_id'],
        songId = parsedJSON['song_id'],
        eventId = parsedJSON['event_id'],
        podcastLibraryId = parsedJSON['podcast_library_id'],
        podcastId = parsedJSON['podcast_id'],
        timezone = parsedJSON['timezone'],
        type = parsedJSON['type'],
        shortDescription = parsedJSON['short_description'],
        longDescription = parsedJSON['long_description'];
}
