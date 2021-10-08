class BibleResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleDataModal data;

  BibleResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleDataModal.fromJSON(parsedJSON['data']);
}

class BibleChapterDetailResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleChapterDetailModal data;

  BibleChapterDetailResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleChapterDetailModal.fromJSON(parsedJSON['data']);
}

class BibleDataModal {
  final List<BibleModal> bible;
  final String lsmCopyright;

  BibleDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : bible = (parsedJSON["bible"] == null)
            ? null
            : (parsedJSON["bible"] as List)
                .map((b) => BibleModal.fromJSON(b))
                .toList(),
        lsmCopyright = parsedJSON['lsm_copyright'];
}

class BibleModal {
  final String title;
  final List<BibleBookModal> books;
  bool isExpanded = false;

  BibleModal.fromJSON(Map<String, dynamic> parsedJSON)
      : title = parsedJSON['title'],
        books = (parsedJSON["books"] == null)
            ? null
            : (parsedJSON["books"] as List)
                .map((b) => BibleBookModal.fromJSON(b))
                .toList();
}

class BibleBookModal {
  final int id;
  final String name;
  final String testament;
  final int genre;
  final int chapters;
  final List<BookChapterModal> bookChapters;

  BibleBookModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        name = parsedJSON['name'],
        testament = parsedJSON['testament'],
        genre = parsedJSON['genre'],
        chapters = parsedJSON['chapters'],
        bookChapters = (parsedJSON["book_chapters"] == null)
            ? null
            : (parsedJSON["book_chapters"] as List)
                .map((b) => BookChapterModal.fromJSON(b))
                .toList();
}

class BookChapterModal {
  final int id;
  final int bibleBookId;
  final String name;
  final String abbrName;
  final int endOfBook;
  final int verses;

  BookChapterModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        bibleBookId = parsedJSON['bible_book_id'],
        name = parsedJSON['name'],
        abbrName = parsedJSON['abbr_name'],
        endOfBook = parsedJSON['end_of_book'],
        verses = parsedJSON['verses'];
}

class BibleChapterDetailModal {
  final BookChapterModal chapter;
  final List<BibleChapterReadingModal> chapterReadings;
  final List<String> medias;

  BibleChapterDetailModal.fromJSON(Map<String, dynamic> parsedJSON)
      : chapter = BookChapterModal.fromJSON(parsedJSON['chapter']),
        chapterReadings = (parsedJSON["chapter_readings"] == null)
            ? null
            : (parsedJSON["chapter_readings"] as List)
                .map((b) => BibleChapterReadingModal.fromJSON(b))
                .toList(),
        medias = (parsedJSON['medias'] == null)
            ? null
            : List.from(parsedJSON['medias']);
}

class BibleChapterReadingModal {
  final int id;
  final String verseRef;
  final text;

  BibleChapterReadingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        verseRef = parsedJSON['verse_ref'],
        text = parsedJSON['text'];
}

//
//Bible Settings

class BibleSettingsResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleSettingsModal data;

  BibleSettingsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleSettingsModal.fromJSON(parsedJSON['data']);
}

class BibleSettingsModal {
  final String selectedSetting;
  final BibleSettingsSummaryModal summary;
  final List<BibleSettingModal> settings;
  final String lsmCopyright;

  BibleSettingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : selectedSetting = parsedJSON['selected_setting'],
        summary = BibleSettingsSummaryModal.fromJSON(parsedJSON['summary']),
        settings = (parsedJSON['settings'] == null)
            ? null
            : (parsedJSON["settings"] as List)
                .map((b) => BibleSettingModal.fromJSON(b))
                .toList(),
        lsmCopyright = parsedJSON['lsm_copyright'];
}

class BibleSettingModal {
  final String type;
  final String title;
  final String description;
  final List<BibleSettingChapterModal> chapters;

  BibleSettingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : type = parsedJSON['type'],
        title = parsedJSON['title'],
        description = parsedJSON['description'],
        chapters = (parsedJSON["chapters"] == null)
            ? null
            : (parsedJSON["chapters"] as List)
                .map((b) => BibleSettingChapterModal.fromJSON(b))
                .toList();
}

class BibleSettingChapterModal {
  final int id;
  final String name;

  BibleSettingChapterModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        name = parsedJSON['name'];
}

class BibleSettingsSummaryModal {
  String title;
  String description;
  String daysReadTitle;
  int readInWeek;
  int noOfDays;
  String todayReadingText;
  bool todayReadingTick;
  List<BibleReadingListingsModal> readingListings;

  BibleSettingsSummaryModal.fromJSON(Map<String, dynamic> parsedJSON)
      : title = parsedJSON['title'],
        description = parsedJSON['description'],
        daysReadTitle = parsedJSON['days_read_title'],
        readInWeek = parsedJSON['read_in_week'],
        noOfDays = parsedJSON['no_of_days'],
        todayReadingText = parsedJSON['today_reading_text'],
        todayReadingTick = parsedJSON['today_reading_tick'],
        readingListings = (parsedJSON["reading_listings"] == null)
            ? null
            : (parsedJSON["reading_listings"] as List)
                .map((b) => BibleReadingListingsModal.fromJSON(b))
                .toList();
}

class BibleReadingListingsModal {
  String label;
  String value;

  BibleReadingListingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : label = parsedJSON['label'],
        value = parsedJSON['value'];
}

//
//
//Bible Reading Schedule

class BibleReadingScheduleResponseModal {
  final bool status;
  final int code;
  final String message;
  final List<BibleReadingScheduleModal> data;

  BibleReadingScheduleResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = (parsedJSON["data"] == null)
            ? null
            : (parsedJSON["data"] as List)
                .map((b) => BibleReadingScheduleModal.fromJSON(b))
                .toList();
}

class BibleReadingTrackResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleReadingTrackModal data;

  BibleReadingTrackResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleReadingTrackModal.fromJSON(parsedJSON['data']);
}

class BibleReadingTrackModal {
  final BibleReadingModal readings;
  final List<String> medias;

  BibleReadingTrackModal.fromJSON(Map<String, dynamic> parsedJSON)
      : readings = BibleReadingModal.fromJSON(parsedJSON['readings']),
        medias = (parsedJSON['medias'] == null)
            ? null
            : List.from(parsedJSON['medias']);
}

class BibleReadingScheduleModal {
  final String date;
  final String day;
  final String dayDate;
  final int scheduleId;
  final List<BibleReadingModal> readings;
  final List<String> medias;

  BibleReadingScheduleModal.fromJSON(Map<String, dynamic> parsedJSON)
      : date = parsedJSON['date'],
        day = parsedJSON['day'],
        dayDate = parsedJSON['day_date'],
        scheduleId = parsedJSON['schedule_id'],
        readings = (parsedJSON["readings"] == null)
            ? null
            : (parsedJSON["readings"] as List)
                .map((b) => BibleReadingModal.fromJSON(b))
                .toList(),
        medias = (parsedJSON['medias'] == null)
            ? null
            : List.from(parsedJSON['medias']);
}

class BibleReadingModal {
  final int id;
  final int bibleChapterId;
  final String testament;
  final int portionNumber;
  final String portionName;
  final String portionShortName;
  final int startVerseId;
  final int endVerseId;
  final int verseCount;
  final String mediaUrl;
  final int status;
  final String createdAt;
  final String updatedAt;
  bool isRead;

  BibleReadingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        bibleChapterId = parsedJSON['bible_chapter_id'],
        testament = parsedJSON['testament'],
        portionNumber = parsedJSON['portion_number'],
        portionName = parsedJSON['portion_name'],
        portionShortName = parsedJSON['portion_short_name'],
        startVerseId = parsedJSON['start_verse_id'],
        endVerseId = parsedJSON['end_verse_id'],
        verseCount = parsedJSON['verse_count'],
        mediaUrl = parsedJSON['media_url'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'],
        isRead = parsedJSON['is_read'] ?? false;
}

//
////
///
/// Get bible reading response
class BibleReadingResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleChapterReadingsModal data;

  BibleReadingResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleChapterReadingsModal.fromJSON(parsedJSON['data']);
}

class BibleChapterReadingsModal {
  List<BibleChapterReadingModal> readings;
  List<String> medias;

  BibleChapterReadingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : readings = (parsedJSON["readings"] == null)
            ? null
            : (parsedJSON["readings"] as List)
                .map((b) => BibleChapterReadingModal.fromJSON(b))
                .toList(),
        medias = (parsedJSON['medias'] == null)
            ? null
            : List.from(parsedJSON['medias']);
}

//
//
//
//

class BibleNextReadingResponseModal {
  final bool status;
  final int code;
  final String message;
  final BibleNextReadingModal data;

  BibleNextReadingResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = BibleNextReadingModal.fromJSON(parsedJSON['data']);
}

class BibleNextReadingModal {
  final BibleReadingModal nextReadingInfo;

  BibleNextReadingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : nextReadingInfo = (parsedJSON['next_reading_info'] == null)
            ? null
            : BibleReadingModal.fromJSON(parsedJSON['next_reading_info']);
}
