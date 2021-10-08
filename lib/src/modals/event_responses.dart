class EventsResponseModal {
  final bool status;
  final int code;
  final String message;
  final EventsModal data;

  EventsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = EventsModal.fromJSON(parsedJSON['data']);
}

class EventsModal {
  final List<EventModal> events;

  EventsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : events = (parsedJSON["events"] == null)
            ? null
            : (parsedJSON["events"] as List)
                .map((b) => EventModal.fromJSON(b))
                .toList();
}

class EventModal {
  int id;
  String eventName;
  int isInvite;
  String shortDescription;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String timezone;

  EventModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        eventName = parsedJSON["event_name"],
        isInvite = parsedJSON["is_invite"],
        shortDescription = parsedJSON['short_description'],
        startDate = parsedJSON['start_date'],
        endDate = parsedJSON['end_date'],
        startTime = parsedJSON['start_time'],
        endTime = parsedJSON['end_time'],
        timezone = parsedJSON['timezone'];
}

//
//
//
//Event detail
//

class EventDetailResponseModal {
  final bool status;
  final int code;
  final String message;
  final EventInfoModal data;

  EventDetailResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = EventInfoModal.fromJSON(parsedJSON['data']);
}

class EventInfoModal {
  final EventDetailInfoModal eventInfo;

  EventInfoModal.fromJSON(Map<String, dynamic> parsedJSON)
      : eventInfo = EventDetailInfoModal.fromJSON(parsedJSON["event_info"]);
}

class EventDetailInfoModal {
  int id;
  String availableForClub;
  String availableForGroup;
  int isInvite;
  String eventName;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String startDateTime;
  String endDateTime;
  String timezone;
  String shortDescription;
  String longDescription;
  String registrationRequired;

  EventDetailInfoModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        availableForClub = parsedJSON["available_for_club"],
        availableForGroup = parsedJSON["available_for_group"],
        isInvite = parsedJSON['is_invite'],
        eventName = parsedJSON['event_name'],
        startDate = parsedJSON['start_date'],
        startTime = parsedJSON['start_time'],
        endDate = parsedJSON['end_date'],
        endTime = parsedJSON['end_time'],
        timezone = parsedJSON['timezone'],
        startDateTime = parsedJSON['start_date_time'],
        endDateTime = parsedJSON['end_date_time'],
        shortDescription = parsedJSON['short_description'],
        longDescription = parsedJSON['long_description'],
        registrationRequired = parsedJSON['registration_required'];
}
