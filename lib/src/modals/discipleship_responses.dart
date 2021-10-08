class DiscipleshipLibrariesResponseModal {
  final bool status;
  final int code;
  final String message;
  final DiscipleshipLibraries data;

  DiscipleshipLibrariesResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = DiscipleshipLibraries.fromJSON(parsedJSON['data']);
}

class DiscipleshipLibraries {
  String discipleshipCoverImage;
  List<DiscipleshipLibrary> discipleshipLibraries;

  DiscipleshipLibraries.fromJSON(Map<String, dynamic> parsedJSON)
      : discipleshipCoverImage = parsedJSON['discipleship_cover_image'],
        discipleshipLibraries = (parsedJSON["discipleship_libraries"] == null)
            ? null
            : (parsedJSON["discipleship_libraries"] as List)
                .map((b) => DiscipleshipLibrary.fromJSON(b))
                .toList();
}

class DiscipleshipLibrary {
  int id;
  String title;
  String shortDescription;
  String coverImage;
  int status;
  String coverImageUrl;

  DiscipleshipLibrary.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        title = parsedJSON['title'],
        shortDescription = parsedJSON['short_description'],
        coverImage = parsedJSON['cover_image'],
        status = parsedJSON['status'],
        coverImageUrl = parsedJSON['cover_image_url'];
}

//
//
//
//Podcast Detail

class DiscipleshipLibraryResponseModal {
  final bool status;
  final int code;
  final String message;
  final DiscipleshipLibraryDataModal data;

  DiscipleshipLibraryResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = DiscipleshipLibraryDataModal.fromJSON(parsedJSON['data']);
}

class DiscipleshipLibraryDataModal {
  DiscipleshipLibraryDetailModal discipleshipLibrary;

  DiscipleshipLibraryDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : discipleshipLibrary = DiscipleshipLibraryDetailModal.fromJSON(
            parsedJSON['discipleship_library']);
}

class DiscipleshipLibraryDetailModal {
  int id;
  String title;
  String shortDescription;
  String coverImage;
  String coverImageUrl;
  List<DiscipleshipModal> discipleships;

  DiscipleshipLibraryDetailModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        title = parsedJSON['title'],
        shortDescription = parsedJSON['short_description'],
        coverImage = parsedJSON['cover_image'],
        coverImageUrl = parsedJSON['cover_image_url'],
        discipleships = (parsedJSON["discipleships"] == null)
            ? null
            : (parsedJSON["discipleships"] as List)
                .map((b) => DiscipleshipModal.fromJSON(b))
                .toList();
}

class DiscipleshipModal {
  int id;
  int discipleshipLibraryId;
  String title;
  String webUrl;

  DiscipleshipModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        discipleshipLibraryId = parsedJSON['discipleship_library_id'],
        title = parsedJSON['title'],
        webUrl = parsedJSON['web_url'];
}
