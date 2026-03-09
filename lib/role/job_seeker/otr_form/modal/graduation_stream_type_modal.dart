class GraduationStreamTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<GraduationStreamTypeData>? data;

  GraduationStreamTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GraduationStreamTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GraduationStreamTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new GraduationStreamTypeData.fromJson(v));
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

class GraduationStreamTypeData {
  int? dropID;
  String? name;
  // String? enumValue;
  // String? name;
  // String? code;
  // String? unit;
  // String? qty;
  // String? typeId;
  // String? eventName;
  // String? mstCommon;
  // String? counselorName;
  // String? sessionDate;
  // String? startTime;
  // String? endTime;
  // String? sessionId;
  // String? description;
  // String? sessionLink;
  // String? types;
  // String? startDate;
  // String? endDate;
  // String? age;
  // String? contactNo;
  // String? email;
  // String? qualificationENG;
  // String? gender;
  // String? districtEn;
  // String? recommendationDate;
  // String? recommendationStatus;
  // String? jobSeekerName;
  // String? mobileNumber;
  // String? jobDescription;
  // String? districtName;
  // String? cityName;
  // String? qualificationName;
  // String? counsellorID;
  // String? educationStreamID;

  GraduationStreamTypeData({
    this.dropID,
    this.name,
    // this.enumValue,
    // this.name,
    // this.code,
    // this.unit,
    // this.qty,
    // this.typeId,
    // this.eventName,
    // this.mstCommon,
    // this.counselorName,
    // this.sessionDate,
    // this.startTime,
    // this.endTime,
    // this.sessionId,
    // this.description,
    // this.sessionLink,
    // this.types,
    // this.startDate,
    // this.endDate,
    // this.age,
    // this.contactNo,
    // this.email,
    // this.qualificationENG,
    // this.gender,
    // this.districtEn,
    // this.recommendationDate,
    // this.recommendationStatus,
    // this.jobSeekerName,
    // this.mobileNumber,
    // this.jobDescription,
    // this.districtName,
    // this.cityName,
    // this.qualificationName,
    // this.counsellorID,
    // this.educationStreamID,
  });

  GraduationStreamTypeData.fromJson(Map<String, dynamic> json) {
    // dropID = json['ID'];
    // streamName = json['StreamName'];

    dropID = json['EducationStreamID'];
    name = json['StreamName'];

    // enumValue = json['EnumValue'];
    // name = json['Name'];
    // code = json['Code'];
    // unit = json['Unit'];
    // qty = json['Quantity'];
    // typeId = json['TypeID'];
    // eventName = json['EventName'];
    // mstCommon = json['mst_Common'];
    // counselorName = json['CounselorName'];
    // sessionDate = json['sessionDate'];
    // startTime = json['startTime'];
    // endTime = json['endTime'];
    // sessionId = json['SessionId'];
    // description = json['Description'];
    // sessionLink = json['SessionLink'];
    // types = json['types'];
    // startDate = json['StartDate'];
    // endDate = json['EndDate'];
    // age = json['Age'];
    // contactNo = json['ContactNo'];
    // email = json['Email'];
    // qualificationENG = json['Qualification_ENG'];
    // gender = json['Gender'];
    // districtEn = json['DistrictEn'];
    // recommendationDate = json['RecommendationDate'];
    // recommendationStatus = json['RecommendationStatus'];
    // jobSeekerName = json['JobSeekerName'];
    // mobileNumber = json['MobileNumber'];
    // jobDescription = json['JobDescription'];
    // districtName = json['DistrictName'];
    // cityName = json['CityName'];
    // qualificationName = json['QualificationName'];
    // counsellorID = json['CounsellorID'];
    // educationStreamID = json['EducationStreamID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['ID'] = this.dropID;
    // data['StreamName'] = this.streamName;

    data['EducationStreamID'] = this.dropID;
    data['StreamName'] = this.name;

    // data['EnumValue'] = this.enumValue;
    // data['Name'] = this.name;
    // data['Code'] = this.code;
    // data['Unit'] = this.unit;
    // data['Quantity'] = this.qty;
    // data['TypeID'] = this.typeId;
    // data['EventName'] = this.eventName;
    // data['mst_Common'] = this.mstCommon;
    // data['CounselorName'] = this.counselorName;
    // data['sessionDate'] = this.sessionDate;
    // data['startTime'] = this.startTime;
    // data['endTime'] = this.endTime;
    // data['SessionId'] = this.sessionId;
    // data['Description'] = this.description;
    // data['SessionLink'] = this.sessionLink;
    // data['types'] = this.types;
    // data['StartDate'] = this.startDate;
    // data['EndDate'] = this.endDate;
    // data['Age'] = this.age;
    // data['ContactNo'] = this.contactNo;
    // data['Email'] = this.email;
    // data['Qualification_ENG'] = this.qualificationENG;
    // data['Gender'] = this.gender;
    // data['DistrictEn'] = this.districtEn;
    // data['RecommendationDate'] = this.recommendationDate;
    // data['RecommendationStatus'] = this.recommendationStatus;
    // data['JobSeekerName'] = this.jobSeekerName;
    // data['MobileNumber'] = this.mobileNumber;
    // data['JobDescription'] = this.jobDescription;
    // data['DistrictName'] = this.districtName;
    // data['CityName'] = this.cityName;
    // data['QualificationName'] = this.qualificationName;
    // data['CounsellorID'] = this.counsellorID;
    // data['EducationStreamID'] = this.educationStreamID;
    return data;
  }
}
