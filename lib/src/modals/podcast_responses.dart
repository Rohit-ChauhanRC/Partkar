class PodcastLibrariesResponseModal {
  final bool status;
  final int code;
  final String message;
  final PodcastLibraries data;

  PodcastLibrariesResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = PodcastLibraries.fromJSON(parsedJSON['data']);
}

class PodcastLibraries {
  String podcastCoverImage;
  String mediaUrl;
  List<PodcastLibrary> podcastsLibraries;

  PodcastLibraries.fromJSON(Map<String, dynamic> parsedJSON)
      : podcastCoverImage = parsedJSON['podcast_cover_image'],
        mediaUrl = parsedJSON['media_url'],
        podcastsLibraries = (parsedJSON["podcasts_libraries"] == null)
            ? null
            : (parsedJSON["podcasts_libraries"] as List)
                .map((b) => PodcastLibrary.fromJSON(b))
                .toList();
}

class PodcastLibrary {
  int id;
  String availableFor;
  String title;
  String shortDescription;
  String coverImage;
  int status;
  String createdAt;
  String updatedAt;
  List<PodcastModal> podcasts;

  PodcastLibrary.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        availableFor = parsedJSON['available_for'],
        title = parsedJSON['title'],
        shortDescription = parsedJSON['short_description'],
        coverImage = parsedJSON['cover_image'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'],
        podcasts = (parsedJSON["podcasts"] == null)
            ? null
            : (parsedJSON["podcasts"] as List)
                .map((b) => PodcastModal.fromJSON(b))
                .toList();
}

//
//
//
//Podcast Detail

class PodacastLibraryResponseModal {
  final bool status;
  final int code;
  final String message;
  final PodcastLibraryDataModal data;

  PodacastLibraryResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = PodcastLibraryDataModal.fromJSON(parsedJSON['data']);
}

class PodcastLibraryDataModal {
  String mediaUrl;
  PodcastLibrary podcastLibrary;

  PodcastLibraryDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : mediaUrl = parsedJSON['media_url'],
        podcastLibrary = PodcastLibrary.fromJSON(parsedJSON['podcast_library']);
}

class PodcastModal {
  int id;
  int podcastLibraryId;
  String title;
  String shortDescription;
  String coverImage;
  String speaker;
  String length;
  String podcastDate;
  String mediaUrl;
  int status;
  String createdAt;
  String updatedAt;

  PodcastModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        podcastLibraryId = parsedJSON['podcast_library_id'],
        title = parsedJSON['title'],
        shortDescription = parsedJSON['short_description'],
        coverImage = parsedJSON['cover_image'],
        speaker = parsedJSON['speaker'],
        length = parsedJSON['length'],
        podcastDate = parsedJSON['podcast_date'],
        mediaUrl = parsedJSON['media_url'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'];
}
