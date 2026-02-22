class AppliedJobModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<AppliedJobItem>? data;

  AppliedJobModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  AppliedJobModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null && json['Data']['Table'] != null) {
      data = <AppliedJobItem>[];
      json['Data']['Table'].forEach((v) {
        data!.add(AppliedJobItem.fromJson(v));
      });
    }
  }
}

class AppliedJobItem {
  int? jobPostId;
  int? employerUserId;
  String? jobTitle;
  String? jobStartDate;
  String? jobCloseDate;
  double? salary;
  String? companyName;
  String? logo;
  String? locations;
  String? employementType;

  AppliedJobItem({
    this.jobPostId,
    this.employerUserId,
    this.jobTitle,
    this.jobStartDate,
    this.jobCloseDate,
    this.salary,
    this.companyName,
    this.logo,
    this.locations,
    this.employementType,
  });

  factory AppliedJobItem.fromJson(Map<String, dynamic> json) {
    return AppliedJobItem(
      jobPostId: json['JobPostId'],
      employerUserId: json['EmployerUserId'],
      jobTitle: json['JobTitle'],
      jobStartDate: json['JobStartDate'],
      jobCloseDate: json['JobCloseDate'],
      salary: (json['Salary'] as num?)?.toDouble(),
      companyName: json['CompanyName'],
      logo: json['Logo'],
      locations: json['Locations'],
      employementType: json['EmployementType'],
    );
  }
}
