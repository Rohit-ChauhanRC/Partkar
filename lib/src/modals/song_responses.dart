class SongsResponseModal {
  final bool status;
  final int code;
  final String message;
  final SongsModal data;

  SongsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = SongsModal.fromJSON(parsedJSON['data']);
}

class SongsModal {
  final List<SongModal> songs;

  SongsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : songs = (parsedJSON["songs"] == null)
            ? null
            : (parsedJSON["songs"] as List)
                .map((b) => SongModal.fromJSON(b))
                .toList();
}

class SongModal {
  final int id;
  final int numberInSection;
  final String availableFor;
  final String songName;
  final int sectionId;
  final String songNumber;
  final String songFirstline;
  final String songChorus;
  final String songKey;
  final int hasChords;
  final int status;
  final String sectionName;
  final String sectionCode;
  final int sortOrder;
  bool isChorus = false;
  String displayName;

  SongModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        numberInSection = parsedJSON['number_in_section'],
        availableFor = parsedJSON['available_for'],
        songName = parsedJSON['song_name'],
        sectionId = parsedJSON['section_id'],
        songNumber = parsedJSON['song_number'],
        songFirstline = parsedJSON['song_firstline'],
        songChorus = parsedJSON['song_chorus'],
        songKey = parsedJSON['song_key'],
        hasChords = parsedJSON['has_chords'],
        status = parsedJSON['status'],
        sectionName = parsedJSON['section_name'],
        sectionCode = parsedJSON['section_code'],
        sortOrder = parsedJSON['sort_order'];

  SongModal.copyWith(SongModal song)
      : id = song.id,
        numberInSection = song.numberInSection,
        availableFor = song.availableFor,
        songName = song.songName,
        sectionId = song.sectionId,
        songNumber = song.songNumber,
        songFirstline = song.songFirstline,
        songChorus = song.songChorus,
        songKey = song.songKey,
        hasChords = song.hasChords,
        status = song.status,
        sectionName = song.sectionName,
        sectionCode = song.sectionCode,
        sortOrder = song.sortOrder;
}

//
//
// Song detail

class SongDetailsResponseModal {
  final bool status;
  final int code;
  final String message;
  final SongDetailsModal data;

  SongDetailsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = SongDetailsModal.fromJSON(parsedJSON['data']);
}

class SongDetailsModal {
  final SongDetailModal song;

  SongDetailsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : song = SongDetailModal.fromJSON(parsedJSON["song"]);
}

class SongDetailModal {
  final int id;
  final String availableFor;
  final int sectionId;
  final String songNumber;
  final String songName;
  final String songFirstline;
  final String songChorus;
  final String songKey;
  final String capo;
  final String keyWithCapo;
  final String songText;
  final int hasChords;
  final int status;
  final List<SongMediaModal> media;
  final SongSectionModal section;

  SongDetailModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        availableFor = parsedJSON['available_for'],
        sectionId = parsedJSON['section_id'],
        songNumber = parsedJSON['song_number'],
        songName = parsedJSON['song_name'],
        songFirstline = parsedJSON['song_firstline'],
        songChorus = parsedJSON['song_chorus'],
        songKey = parsedJSON['song_key'],
        capo = parsedJSON['capo'],
        keyWithCapo = parsedJSON['key_with_capo'],
        songText = parsedJSON['song_text'],
        hasChords = parsedJSON['has_chords'],
        status = parsedJSON['status'],
        media = (parsedJSON["media"] == null)
            ? null
            : (parsedJSON["media"] as List)
                .map((b) => SongMediaModal.fromJSON(b))
                .toList(),
        section = SongSectionModal.fromJSON(parsedJSON['section']);
}

class SongSectionModal {
  final int id;
  final String sectionName;
  final String sectionCode;
  final int sortOrder;
  final int status;
  final String createdAt;
  final String updatedAt;

  SongSectionModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        sectionName = parsedJSON['section_name'],
        sectionCode = parsedJSON['section_code'],
        sortOrder = parsedJSON['sort_order'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'];
}

class SongMediaModal {
  int id;
  int songId;
  String title;
  String mediaUrl;

  SongMediaModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        songId = parsedJSON['song_id'],
        title = parsedJSON['title'],
        mediaUrl = parsedJSON['media_url'];
}
