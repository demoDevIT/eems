class JobDetailsModal {
  int? state;
  JobDetailsData? data;

  JobDetailsModal({this.state, this.data});

  JobDetailsModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    data =
    json['Data'] != null ? JobDetailsData.fromJson(json['Data']) : null;
  }
}

class JobDetailsData {
  String? jobTitle;
  String? companyName;
  String? description;
  String? jobStartDate;
  String? jobCloseDate;
  String? skillNameEn;
  String? qualificationENG;
  String? jobSector;
  String? maleGender;
  int? salary;
  String? locations;

  JobDetailsData.fromJson(Map<String, dynamic> json) {
    jobTitle = json['JobTitle'];
    companyName = json['CompanyName'];
    description = json['Description'];
    jobStartDate = json['JobStartDate'];
    jobCloseDate = json['JobCloseDate'];
    skillNameEn = json['SkillNameEn'];
    qualificationENG = json['QualificationENG'];
    jobSector = json['JobSector'];
    maleGender = json['MaleGender'];
    salary = json['Salary'];
    locations = json['Locations'];
  }
}