class EventModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<EventData>? data;

  EventModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  EventModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <EventData>[];
      json['Data'].forEach((v) {
        data!.add(EventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['State'] = state;
    dataMap['Status'] = status;
    dataMap['Message'] = message;
    dataMap['ErrorMessage'] = errorMessage;

    if (data != null) {
      dataMap['Data'] = data!.map((v) => v.toJson()).toList();
    }

    return dataMap;
  }
}

class EventData {
  int? eventId;
  String? eventNameEng;
  String? eventNameHi;

  EventData({
    this.eventId,
    this.eventNameEng,
    this.eventNameHi,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    eventId = json['EventId'];
    eventNameEng = json['EventName_ENG'];
    eventNameHi = json['EventName_HI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['EventId'] = eventId;
    data['EventName_ENG'] = eventNameEng;
    data['EventName_HI'] = eventNameHi;

    return data;
  }
}