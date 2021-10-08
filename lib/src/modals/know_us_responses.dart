class KnowUsResponseModal {
  final bool status;
  final int code;
  final String message;
  final KnowUsModals data;

  KnowUsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = KnowUsModals.fromJSON(parsedJSON['data']);
}

class KnowUsModals {
  final String mediaUrl;
  final List<KnowUsModal> getToKnowUs;

  KnowUsModals.fromJSON(Map<String, dynamic> parsedJSON)
      : mediaUrl = parsedJSON["media_url"],
        getToKnowUs = (parsedJSON["get_to_know_us"] == null)
            ? null
            : (parsedJSON["get_to_know_us"] as List)
                .map((b) => KnowUsModal.fromJSON(b))
                .toList();
}

class KnowUsModal {
  int id;
  int clubId;
  String type;
  String title;
  String mainImage;
  String coverImage;
  String description;
  String googleFormUrl;
  int status;
  String createdAt;
  String updatedAt;

  KnowUsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubId = parsedJSON["club_id"],
        type = parsedJSON["type"],
        title = parsedJSON['title'],
        mainImage = parsedJSON['main_image'],
        coverImage = parsedJSON['cover_image'],
        description = parsedJSON['description'],
        googleFormUrl = parsedJSON['google_form_url'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'];
}

//
//
//
//
//Social links

class SocialLinksResponseModal {
  final bool status;
  final int code;
  final String message;
  final SocialMediaModal data;

  SocialLinksResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = SocialMediaModal.fromJSON(parsedJSON['data']);
}

class SocialMediaModal {
  final String mediaUrl;
  final List<SocialLinkModal> socialMedia;

  SocialMediaModal.fromJSON(Map<String, dynamic> parsedJSON)
      : mediaUrl = parsedJSON["media_url"],
        socialMedia = (parsedJSON["social_media"] == null)
            ? null
            : (parsedJSON["social_media"] as List)
                .map((b) => SocialLinkModal.fromJSON(b))
                .toList();
}

class SocialLinkModal {
  int id;
  int clubId;
  String title;
  String image;
  String username;
  String url;
  String appURL;
  int status;
  int sort;

  SocialLinkModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubId = parsedJSON["club_id"],
        title = parsedJSON['title'],
        image = parsedJSON["image"],
        username = parsedJSON['username'],
        url = parsedJSON['url'],
        appURL = parsedJSON['app_url'],
        status = parsedJSON["status"],
        sort = parsedJSON['sort'];
}
