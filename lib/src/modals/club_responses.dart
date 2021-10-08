import 'package:flutter/material.dart';

class AllClubsResponseModal {
  final bool status;
  final int code;
  final String message;
  final ClubsModal data;

  AllClubsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = ClubsModal.fromJSON(parsedJSON['data']);
}

class ClubsModal {
  final ClubMediaInfoModal clubInfo;
  final List<ClubModal> clubs;

  ClubsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : clubInfo = ClubMediaInfoModal.fromJSON(parsedJSON['club_info']),
        clubs = (parsedJSON["clubs"] as List)
            .map((c) => ClubModal.fromJSON(c))
            .toList();
}

class ClubMediaInfoModal {
  final String clubMediaUrl;

  ClubMediaInfoModal.fromJSON(Map<String, dynamic> parsedJSON)
      : clubMediaUrl = parsedJSON["club_media_url"];
}

class ClubModal {
  final int id;
  final String clubCode;
  final String clubName;
  final String clubLogo;
  final String clubLogoNightMode;
  final String contactPerson;
  final String contactMobile;
  final String contactEmail;
  final String addressLine1;
  final String addressLine2;
  final String state;
  final String city;
  final String zipcode;
  final String clubTimezone;
  final int status;
  final String createdAt;
  final String updatedAt;

  ClubModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubCode = parsedJSON["club_code"],
        clubName = parsedJSON["club_name"],
        clubLogo = parsedJSON['club_logo'],
        clubLogoNightMode = parsedJSON['club_logo_night_mode'],
        contactPerson = parsedJSON['contact_person'],
        contactMobile = parsedJSON['contact_mobile'],
        contactEmail = parsedJSON['contact_email'],
        addressLine1 = parsedJSON['address_line_1'],
        addressLine2 = parsedJSON['address_line_2'],
        state = parsedJSON['state'],
        city = parsedJSON['city'],
        zipcode = parsedJSON['zipcode'],
        clubTimezone = parsedJSON['club_timezone'],
        status = parsedJSON['status'],
        createdAt = parsedJSON['created_at'],
        updatedAt = parsedJSON['updated_at'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'club_code': clubCode,
      'club_name': clubName,
      'club_logo': clubLogo,
      'contact_person': contactPerson,
      'contact_mobile': contactMobile,
      'contact_email': contactEmail,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'state': state,
      'city': city,
      'zipcode': zipcode,
      'club_timezone': clubTimezone,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ClubColourModesModal {
  final ClubColourModeModal day;
  final ClubColourModeModal night;

  ClubColourModesModal.fromJSON(Map<String, dynamic> parsedJSON)
      : day = ClubColourModeModal.fromJSON(parsedJSON["day"]),
        night = ClubColourModeModal.fromJSON(parsedJSON["night"]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day.toMap(),
      'night': night.toMap(),
    };
  }
}

class ClubColourModeModal {
  int id;
  int clubId;
  String mode;
  String bgColor;
  String headlineColor;
  String accentColor;
  String bodyTextColor;
  String gradientStartColor;
  String gradientEndColor;

  Color bgColour() => Color(int.parse('0xFF${bgColor.replaceFirst('#', '')}'));
  Color headlineColour() =>
      Color(int.parse('0xFF${headlineColor.replaceFirst('#', '')}'));
  Color accentColour() =>
      Color(int.parse('0xFF${accentColor.replaceFirst('#', '')}'));
  Color bodyTextColour() =>
      Color(int.parse('0xFF${bodyTextColor.replaceFirst('#', '')}'));
  Color gradientStartColour() =>
      Color(int.parse('0xFF${gradientStartColor.replaceFirst('#', '')}'));
  Color gradientEndColour() =>
      Color(int.parse('0xFF${gradientEndColor.replaceFirst('#', '')}'));

  ClubColourModeModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubId = parsedJSON["club_id"],
        mode = parsedJSON["mode"],
        bgColor = parsedJSON['bg_color'],
        headlineColor = parsedJSON['headline_color'],
        accentColor = parsedJSON['accent_color'],
        bodyTextColor = parsedJSON['body_text_color'],
        gradientStartColor = parsedJSON['gradient_start_color'],
        gradientEndColor = parsedJSON['gradient_end_color'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'club_id': clubId,
      'mode': mode,
      'bg_color': bgColor,
      'headline_color': headlineColor,
      'accent_color': accentColor,
      'body_text_color': bodyTextColor,
      'gradient_start_color': gradientStartColor,
      'gradient_end_color': gradientEndColor,
    };
  }
}

//-------------------------------------------------------

class ClubInfoResponseModal {
  final bool status;
  final int code;
  final String message;
  final ClubDataModal data;

  ClubInfoResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = ClubDataModal.fromJSON(parsedJSON['data']);
}

class ClubDataModal {
  final ClubInfoModal clubInfo;
  final ClubColourModesModal colorModes;
  final privacyPolicy;
  final tnc;
  final List<ClubSchoolModal> schools;
  final List<ClubSchoolYearModal> yearSchools;

  ClubDataModal.fromJSON(Map<String, dynamic> parsedJSON)
      : clubInfo = ClubInfoModal.fromJSON(parsedJSON['club_info']),
        colorModes = ClubColourModesModal.fromJSON(parsedJSON['color_modes']),
        privacyPolicy = parsedJSON['privacy_policy'],
        tnc = parsedJSON['tnc'],
        schools = (parsedJSON["schools"] == null)
            ? null
            : (parsedJSON["schools"] as List)
                .map((b) => ClubSchoolModal.fromJSON(b))
                .toList(),
        yearSchools = (parsedJSON["year_schools"] == null)
            ? null
            : (parsedJSON["year_schools"] as List)
                .map((b) => ClubSchoolYearModal.fromJSON(b))
                .toList();
}

class ClubInfoModal {
  final int id;
  final String clubCode;
  final String clubName;
  final String clubLogo;
  final String contactPerson;
  final String contactMobile;
  final String contactEmail;
  final String addressLine1;
  final String addressLine2;
  final String state;
  final String city;
  final String zipcode;
  final String clubTimezone;
  final int status;
  final List<ClubInfoColourModeModal> colorModes;

  ClubInfoModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubCode = parsedJSON["club_code"],
        clubName = parsedJSON["club_name"],
        clubLogo = parsedJSON['club_logo'],
        contactPerson = parsedJSON['contact_person'],
        contactMobile = parsedJSON['contact_mobile'],
        contactEmail = parsedJSON['contact_email'],
        addressLine1 = parsedJSON['address_line_1'],
        addressLine2 = parsedJSON['address_line_2'],
        state = parsedJSON['state'],
        city = parsedJSON['city'],
        zipcode = parsedJSON['zipcode'],
        clubTimezone = parsedJSON['club_timezone'],
        status = parsedJSON['status'],
        colorModes = (parsedJSON["color_modes"] == null)
            ? null
            : (parsedJSON["color_modes"] as List)
                .map((b) => ClubInfoColourModeModal.fromJSON(b))
                .toList();
}

class ClubInfoColourModeModal {
  final int id;
  final int clubId;
  final String mode;
  final String bgColor;
  final String headlineColor;
  final String accentColor;
  final String bodyTextColor;
  final String gradientStartColor;
  final String gradientEndColor;

  ClubInfoColourModeModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubId = parsedJSON["club_id"],
        mode = parsedJSON["mode"],
        bgColor = parsedJSON['bg_color'],
        headlineColor = parsedJSON['headline_color'],
        accentColor = parsedJSON['accent_color'],
        bodyTextColor = parsedJSON['body_text_color'],
        gradientStartColor = parsedJSON['gradient_start_color'],
        gradientEndColor = parsedJSON['gradient_end_color'];
}

class ClubSchoolModal {
  final String title;

  ClubSchoolModal.fromJSON(Map<String, dynamic> parsedJSON)
      : title = parsedJSON["title"];
}

class ClubSchoolYearModal {
  final String title;

  ClubSchoolYearModal.fromJSON(Map<String, dynamic> parsedJSON)
      : title = parsedJSON["title"];
}
