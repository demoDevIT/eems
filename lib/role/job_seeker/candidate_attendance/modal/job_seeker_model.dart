class JobSeekerModel {
  final String jobSeekerName;
  final String registrationNo;
  final String higQualification;
  final String mobileNo;
  final String registrationDate;
  final String userId;
  final String roleId;
  final String eventId;

  JobSeekerModel({
    required this.jobSeekerName,
    required this.registrationNo,
    required this.higQualification,
    required this.mobileNo,
    required this.registrationDate,
    required this.userId,
    required this.roleId,
    required this.eventId,
  });

  factory JobSeekerModel.fromJson(Map<String, dynamic> json) {
    return JobSeekerModel(
      jobSeekerName: json['JobSeekerName']?.toString() ?? '',
      registrationNo: json['RegistrationNo']?.toString() ?? '',
      higQualification: json['HigQualification']?.toString() ?? '',
      mobileNo: json['MobileNo']?.toString() ?? '',
      registrationDate: json['RegistrationDate']?.toString() ?? '',
      userId: json['UserId']?.toString() ?? '',
      roleId: json['RoleId']?.toString() ?? '',
      eventId: json['EventId']?.toString() ?? '',
    );
  }
}
