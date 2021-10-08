class MeetingsResponseModal {
  final bool status;
  final int code;
  final String message;
  final MeetingsModal data;

  MeetingsResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = MeetingsModal.fromJSON(parsedJSON['data']);
}

class MeetingsModal {
  final List<MeetingModal> meetings;

  MeetingsModal.fromJSON(Map<String, dynamic> parsedJSON)
      : meetings = (parsedJSON["meetings"] == null)
            ? null
            : (parsedJSON["meetings"] as List)
                .map((b) => MeetingModal.fromJSON(b))
                .toList();
}

class MeetingModal {
  int id;
  int clubId;
  String topic;
  String description;
  String meetingDate;
  String startTime;
  String meetingDay;
  String durationHour;
  String durationMin;

  MeetingModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        clubId = parsedJSON["club_id"],
        topic = parsedJSON["topic"],
        description = parsedJSON['description'],
        meetingDate = parsedJSON['meeting_date'],
        startTime = parsedJSON['start_time'],
        meetingDay = parsedJSON['meeting_day'],
        durationHour = parsedJSON['duration_hour'],
        durationMin = parsedJSON['duration_min'];
}
