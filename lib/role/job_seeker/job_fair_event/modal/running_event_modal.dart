class RunningEventModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<RunningEventData>? data;

  RunningEventModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  RunningEventModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <RunningEventData>[];
      json['Data'].forEach((v) {
        data!.add(new RunningEventData.fromJson(v));
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

class RunningEventData {
  int? jobEventDetailId;
  String? eventId;
  String? eventNameENG;
  String? eventNameHI;
  int? levelId;
  int? divisionId;
  int? districtId;
  int? blockId;
  String? venue;
  String? startDate;
  dynamic startTime;
  String? endDate;
  dynamic endTime;
  String? inchargeName;
  String? contactNumber;
  String? email;
  String? eventDescription;
  String? registrationOpenDate;
  String? levelNameEnglish;
  String? qRCode;
  String? distDivisionName;

  RunningEventData(
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
        this.distDivisionName});

  RunningEventData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
