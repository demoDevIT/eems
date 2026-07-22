class MatchedJobPostModel {
  int? state;
  bool? status;
  String? message;
  MatchedJobData? data;

  MatchedJobPostModel({
    this.state,
    this.status,
    this.message,
    this.data,
  });

  factory MatchedJobPostModel.fromJson(Map<String, dynamic> json) {
    return MatchedJobPostModel(
      state: json['State'],
      status: json['Status'],
      message: json['Message'],
      data: json['Data'] != null
          ? MatchedJobData.fromJson(json['Data'])
          : null,
    );
  }
}

class MatchedJobData {
  List<NcoTable>? table;
  List<JobPostTable>? table1;

  MatchedJobData({
    this.table,
    this.table1,
  });

  factory MatchedJobData.fromJson(Map<String, dynamic> json) {
    return MatchedJobData(
      table: (json['Table'] as List?)
          ?.map((e) => NcoTable.fromJson(e))
          .toList() ??
          [],
      table1: (json['Table1'] as List?)
          ?.map((e) => JobPostTable.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class NcoTable {
  int? rowNum;
  String? ncoCode;
  String? ncoName;
  int? matchedJobPostCount;

  NcoTable.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    ncoCode = json['NCOCode'];
    ncoName = json['NCO_Name'];
    matchedJobPostCount = json['MatchedJobPostCount'];
  }
}

class JobPostTable {
  int? employerUserId;
  int? eventId;
  int? jobPostId;
  bool isSelected = false;

  String? jobPositionTitleEng;
  String? preferedLocation;

  int? minSalary;
  int? maxSalary;

  String? action;

  JobPostTable.fromJson(Map<String, dynamic> json) {
    employerUserId = json['EmployerUserId'];
    eventId = json['EventId'];
    jobPostId = json['JobPostId'];

    jobPositionTitleEng = json['JobPositionTitle_ENG'];
    preferedLocation = json['PreferedLocation'];

    minSalary = json['MinSalary'];
    maxSalary = json['MaxSalary'];

    action = json['Action'];
  }
}