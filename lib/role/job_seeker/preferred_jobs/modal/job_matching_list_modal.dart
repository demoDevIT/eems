class JobMatchingListModal {
  int? state;
  String? message;
  JobMatchingData? data;

  JobMatchingListModal({this.state, this.message, this.data});

  JobMatchingListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    message = json['Message'];
    data = json['Data'] != null
        ? JobMatchingData.fromJson(json['Data'])
        : null;
  }
}

class JobMatchingData {
  List<JobData>? table;

  JobMatchingData({this.table});

  JobMatchingData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <JobData>[];
      json['Table'].forEach((v) {
        table!.add(JobData.fromJson(v));
      });
    }
  }
}

class JobData {
  int? jobPostId;
  String? jobTitle;
  double? salary;
  String? companyName;
  String? locations;
  String? employementType;

  JobData.fromJson(Map<String, dynamic> json) {
    jobPostId = json['JobPostId'];
    jobTitle = json['JobTitle'];
    salary = (json['Salary'] as num?)?.toDouble();
    companyName = json['CompanyName'];
    locations = json['Locations'];
    employementType = json['EmployementType'];
  }
}