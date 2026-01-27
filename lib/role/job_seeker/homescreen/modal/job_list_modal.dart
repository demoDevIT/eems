class JobListModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<JobListData>? data;

  JobListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobListData>[];
      json['Data'].forEach((v) {
        data!.add(new JobListData.fromJson(v));
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

class JobListData {
  int? employerUserId;
  int? eventId;
  String? eventNameENG;
  int? jobPostId;
  String? jobpostName;
  int? maleNoOfVacancy;
  int? femaleNoOfVacancy;
  int? otherNoOfVacancy;
  String? description;
  String? closingDate;
  String? nCOCode;
  String? jobNameEn;
  dynamic organizationName;
  dynamic employerAddress;
  int? jobSectorId;
  int? noOfPreferences;
  String? action;
  String? salary;
  String? employmentType;
  String? preferedLocation;
  int? matchScore;

  JobListData(
      {this.employerUserId,
        this.eventId,
        this.eventNameENG,
        this.jobPostId,
        this.jobpostName,
        this.maleNoOfVacancy,
        this.femaleNoOfVacancy,
        this.otherNoOfVacancy,
        this.description,
        this.closingDate,
        this.nCOCode,
        this.jobNameEn,
        this.organizationName,
        this.employerAddress,
        this.jobSectorId,
        this.noOfPreferences,
        this.action,
        this.salary,
        this.employmentType,
        this.preferedLocation,
        this.matchScore});

  JobListData.fromJson(Map<String, dynamic> json) {
    employerUserId = json['EmployerUserId'];
    eventId = json['EventId'];
    eventNameENG = json['EventName_ENG'];
    jobPostId = json['JobPostId'];
    jobpostName = json['JobpostName'];
    maleNoOfVacancy = json['Male_NoOfVacancy'];
    femaleNoOfVacancy = json['Female_NoOfVacancy'];
    otherNoOfVacancy = json['Other_NoOfVacancy'];
    description = json['Description'];
    closingDate = json['Closing_Date'];
    nCOCode = json['NCO_Code'];
    jobNameEn = json['JobNameEn'];
    organizationName = json['OrganizationName'];
    employerAddress = json['EmployerAddress'];
    jobSectorId = json['JobSectorId'];
    noOfPreferences = json['NoOfPreferences'];
    action = json['Action'];
    salary = json['salary'];
    employmentType = json['EmploymentType'];
    preferedLocation = json['PreferedLocation'];
    matchScore = json['MatchScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployerUserId'] = this.employerUserId;
    data['EventId'] = this.eventId;
    data['EventName_ENG'] = this.eventNameENG;
    data['JobPostId'] = this.jobPostId;
    data['JobpostName'] = this.jobpostName;
    data['Male_NoOfVacancy'] = this.maleNoOfVacancy;
    data['Female_NoOfVacancy'] = this.femaleNoOfVacancy;
    data['Other_NoOfVacancy'] = this.otherNoOfVacancy;
    data['Description'] = this.description;
    data['Closing_Date'] = this.closingDate;
    data['NCO_Code'] = this.nCOCode;
    data['JobNameEn'] = this.jobNameEn;
    data['OrganizationName'] = this.organizationName;
    data['EmployerAddress'] = this.employerAddress;
    data['JobSectorId'] = this.jobSectorId;
    data['NoOfPreferences'] = this.noOfPreferences;
    data['Action'] = this.action;
    data['salary'] = this.salary;
    data['EmploymentType'] = this.employmentType;
    data['PreferedLocation'] = this.preferedLocation;
    data['MatchScore'] = this.matchScore;
    return data;
  }
}
