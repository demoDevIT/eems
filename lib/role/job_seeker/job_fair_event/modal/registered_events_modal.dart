class RegisteredEventsModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<RegisteredEventsData>? data;

  RegisteredEventsModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  RegisteredEventsModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <RegisteredEventsData>[];
      json['Data'].forEach((v) {
        data!.add(new RegisteredEventsData.fromJson(v));
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

class RegisteredEventsData {
  dynamic jobEventDetailId;
  dynamic eventId;
  dynamic eventNameENG;
  dynamic eventNameHI;
  dynamic levelId;
  dynamic divisionId;
  dynamic districtId;
  dynamic blockId;
  dynamic venue;
  dynamic startDate;
  dynamic startTime;
  dynamic endDate;
  dynamic endTime;
  dynamic inchargeName;
  dynamic contactNumber;
  dynamic email;
  dynamic eventDescription;
  dynamic registrationOpenDate;
  dynamic levelNameEnglish;
  dynamic qRCode;
  dynamic distDivisionName;
  dynamic eventType;

  RegisteredEventsData(
      {this.jobEventDetailId,
        this.eventId,
        this.eventNameENG,
        this.eventNameHI,
        this.levelId,
        this.divisionId,
        this.districtId,
        this.blockId,
        this.venue,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.inchargeName,
        this.contactNumber,
        this.email,
        this.eventDescription,
        this.registrationOpenDate,
        this.levelNameEnglish,
        this.qRCode,
        this.distDivisionName,
        this.eventType});

  RegisteredEventsData.fromJson(Map<String, dynamic> json) {
    jobEventDetailId = json['JobEventDetailId'];
    eventId = json['EventId'];
    eventNameENG = json['EventName_ENG'];
    eventNameHI = json['EventName_HI'];
    levelId = json['LevelId'];
    divisionId = json['DivisionId'];
    districtId = json['DistrictId'];
    blockId = json['BlockId'];
    venue = json['Venue'];
    startDate = json['StartDate'];
    startTime = json['StartTime'];
    endDate = json['EndDate'];
    endTime = json['EndTime'];
    inchargeName = json['InchargeName'];
    contactNumber = json['ContactNumber'];
    email = json['Email'];
    eventDescription = json['EventDescription'];
    registrationOpenDate = json['RegistrationOpenDate'];
    levelNameEnglish = json['LevelNameEnglish'];
    qRCode = json['QRCode'];
    distDivisionName = json['Dist_DivisionName'];
    eventType = json['EventType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobEventDetailId'] = this.jobEventDetailId;
    data['EventId'] = this.eventId;
    data['EventName_ENG'] = this.eventNameENG;
    data['EventName_HI'] = this.eventNameHI;
    data['LevelId'] = this.levelId;
    data['DivisionId'] = this.divisionId;
    data['DistrictId'] = this.districtId;
    data['BlockId'] = this.blockId;
    data['Venue'] = this.venue;
    data['StartDate'] = this.startDate;
    data['StartTime'] = this.startTime;
    data['EndDate'] = this.endDate;
    data['EndTime'] = this.endTime;
    data['InchargeName'] = this.inchargeName;
    data['ContactNumber'] = this.contactNumber;
    data['Email'] = this.email;
    data['EventDescription'] = this.eventDescription;
    data['RegistrationOpenDate'] = this.registrationOpenDate;
    data['LevelNameEnglish'] = this.levelNameEnglish;
    data['QRCode'] = this.qRCode;
    data['Dist_DivisionName'] = this.distDivisionName;
    data['EventType'] = this.eventType;
    return data;
  }
}
