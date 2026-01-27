class EventNameModal {
  dynamic state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  List<EventNameData>? data;

  EventNameModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  EventNameModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <EventNameData>[];
      json['Data'].forEach((v) {
        data!.add(new EventNameData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventNameData {
  dynamic dropID;
  dynamic startDate;
  dynamic endDate;
  dynamic name;
  dynamic eventNameHI;

  EventNameData(
      {this.dropID,
        this.startDate,
        this.endDate,
        this.name,
        this.eventNameHI});

  EventNameData.fromJson(Map<String, dynamic> json) {
    dropID = json['EventId'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    name = json['EventName_ENG'];
    eventNameHI = json['EventName_HI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventId'] = this.dropID;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['EventName_ENG'] = this.name;
    data['EventName_HI'] = this.eventNameHI;
    return data;
  }
}
