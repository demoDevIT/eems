class EventModel {
  final int eventId;
  final String eventNameEng;
  final String eventNameHi;

  EventModel({
    required this.eventId,
    required this.eventNameEng,
    required this.eventNameHi,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['EventId'],
      eventNameEng: json['EventName_ENG'],
      eventNameHi: json['EventName_HI'],
    );
  }
}
