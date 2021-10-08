import 'bible_responses.dart';
import 'know_us_responses.dart';
import 'notification_responses.dart';

class HomeDataResponseModal {
  final bool status;
  final int code;
  final String message;
  final HomeDataModal data;

  HomeDataResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = HomeDataModal.fromJSON(parsedJSON['data']);
}

class HomeDataModal {
  List<NotificationModal> notifications;
  HomeReadingsModal bibleReadings;
  BibleSettingsSummaryModal summary;
  String mediaUrl;
  List<KnowUsModal> getToKnowUs;

  HomeDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : notifications = (parsedJSON["notifications"] == null)
            ? null
            : (parsedJSON["notifications"] as List)
                .map((b) => NotificationModal.fromJSON(b))
                .toList(),
        bibleReadings =
            HomeReadingsModal.fromJSON(parsedJSON['bible_readings']),
        summary = BibleSettingsSummaryModal.fromJSON(parsedJSON['summary']),
        mediaUrl = parsedJSON["media_url"],
        getToKnowUs = (parsedJSON["get_to_know_us"] == null)
            ? null
            : (parsedJSON["get_to_know_us"] as List)
                .map((b) => KnowUsModal.fromJSON(b))
                .toList();
}

class HomeReadingsModal {
  List<BibleChapterReadingModal> readingDetail;
  List<BibleReadingModal> todayReadings;

  HomeReadingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : readingDetail = (parsedJSON["reading_detail"] == null)
            ? null
            : (parsedJSON["reading_detail"] as List)
                .map((b) => BibleChapterReadingModal.fromJSON(b))
                .toList(),
        todayReadings = (parsedJSON["today_readings"] == null)
            ? null
            : (parsedJSON["today_readings"] as List)
                .map((b) => BibleReadingModal.fromJSON(b))
                .toList();
}
