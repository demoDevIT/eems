class CommonResponseModel<T> {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<T>? data;

  CommonResponseModel({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CommonResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return CommonResponseModel<T>(
      state: json['State'],
      status: json['Status'],
      message: json['Message'],
      errorMessage: json['ErrorMessage'],
      data: json['Data'] != null
          ? List<T>.from(json['Data'].map((e) => fromJsonT(e)))
          : null,
    );
  }
}


class ActionData {
  dynamic  actionNameEn;
  dynamic  actionNameHi;
  dynamic  applicationNo;
  dynamic  userId;
  dynamic  jobSeekerId;
  dynamic  officeName;
  dynamic  jobEventDetailId;
  dynamic  eventId;
  dynamic  eventNameENG;
  dynamic  eventNameHI;
  dynamic  venue;
  dynamic  startDate;
  dynamic  endDate;
  dynamic  inchargeName;
  dynamic  contactNumber;
  dynamic  eventDescription;
  dynamic  registrationOpenDate;
  dynamic  distDivisionName;

  ActionData(
      {this.actionNameEn,
        this.actionNameHi,
        this.applicationNo,
        this.userId,
        this.jobSeekerId,
        this.officeName,
        this.jobEventDetailId,
        this.eventId,
        this.eventNameENG,
        this.eventNameHI,
        this.venue,
        this.startDate,
        this.endDate,
        this.inchargeName,
        this.contactNumber,
        this.eventDescription,
        this.registrationOpenDate,
        this.distDivisionName});

  ActionData.fromJson(Map<String, dynamic> json) {
    actionNameEn = json['ActionNameEn'];
    actionNameHi = json['ActionNameHi'];
    applicationNo = json['ApplicationNo'];
    userId = json['UserId'];
    jobSeekerId = json['JobSeekerId'];
    officeName = json['OfficeName'];
    jobEventDetailId = json['JobEventDetailId'];
    eventId = json['EventId'];
    eventNameENG = json['EventName_ENG'];
    eventNameHI = json['EventName_HI'];
    venue = json['Venue'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    inchargeName = json['InchargeName'];
    contactNumber = json['ContactNumber'];
    eventDescription = json['EventDescription'];
    registrationOpenDate = json['RegistrationOpenDate'];
    distDivisionName = json['Dist_DivisionName'];
  }


}