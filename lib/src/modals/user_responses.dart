import 'club_responses.dart';

class LoginResponseModal {
  final bool status;
  final int code;
  final String message;
  final LoginModal data;

  LoginResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = LoginModal.fromJSON(parsedJSON['data']);
}

class LoginModal {
  final String token;
  final UserModal user;
  final ClubModal clubinfo;
  final ClubColourModesModal colorModes;

  LoginModal.fromJSON(Map<String, dynamic> parsedJSON)
      : token = parsedJSON['token'],
        user = UserModal.fromJSON(parsedJSON['user']),
        clubinfo = ClubModal.fromJSON(parsedJSON['clubinfo']),
        colorModes = ClubColourModesModal.fromJSON(parsedJSON['color_modes']);
}

class UserModal {
  final int id;
  final int clubId;
  final String type;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String mobile;
  final String gender;
  final String school;
  final String schoolOther;
  final String yearInSchool;
  final String yearInSchoolOther;
  final String emailVerifiedAt;
  final String address;
  final String state;
  final String city;
  final String postcode;
  final String profileImage;
  final String bibleSettings;
  final int status;
  final String profileImageUrl;

  UserModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        clubId = parsedJSON['club_id'],
        type = parsedJSON['type'],
        firstName = parsedJSON['first_name'],
        lastName = parsedJSON['last_name'],
        fullName = parsedJSON['full_name'],
        email = parsedJSON['email'],
        mobile = parsedJSON['mobile'],
        gender = parsedJSON['gender'],
        school = parsedJSON['school'],
        schoolOther = parsedJSON['school_other'],
        yearInSchool = parsedJSON['year_in_school'],
        yearInSchoolOther = parsedJSON['year_in_school_other'],
        emailVerifiedAt = parsedJSON['email_verified_at'],
        address = parsedJSON['address'],
        state = parsedJSON['state'],
        city = parsedJSON['city'],
        postcode = parsedJSON['postcode'],
        profileImage = parsedJSON['profile_image'],
        bibleSettings = parsedJSON['bible_settings'],
        status = parsedJSON['status'],
        profileImageUrl = parsedJSON['profile_image_url'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'club_id': clubId,
      'type': type,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'school': school,
      'school_other': schoolOther,
      'year_in_school': yearInSchool,
      'year_in_school_other': yearInSchoolOther,
      'email_verified_at': emailVerifiedAt,
      'address': address,
      'state': state,
      'city': city,
      'postcode': postcode,
      'profile_image': profileImage,
      'bible_settings': bibleSettings,
      'status': status,
      'profile_image_url': profileImageUrl,
    };
  }
}

//
//
//
// Profile Responses

class ProfileResponseModal {
  final bool status;
  final int code;
  final String message;
  final ProfileModal data;

  ProfileResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = ProfileModal.fromJSON(parsedJSON['data']);
}

class ProfileModal {
  final UserModal user;

  ProfileModal.fromJSON(Map<String, dynamic> parsedJSON)
      : user = UserModal.fromJSON(parsedJSON['user']);
}
