class MarkAttendanceBasicDetails {
  int? joiningID;
  int? jobSeekerID;
  int? userID;
  String? applicantName;
  String? fatherName;
  String? courseName;
  String? joiningDate;
  int? attendanceDays;
  String? departmentName;
  String? address;
  String? districtName;
  String? registrationNo;

  MarkAttendanceBasicDetails.fromJson(Map<String, dynamic> json) {
    joiningID = json['JoiningID'];
    jobSeekerID = json['JobSeekerID'];
    userID = json['UserID'];
    applicantName = json['applicantName'];
    fatherName = json['fatherName'];
    courseName = json['courseName'];
    joiningDate = json['joiningDate'];
    attendanceDays = json['AttendanceDays'];
    departmentName = json['departmentName'];
    address = json['Address'];
    districtName = json['DistrictName'];
    registrationNo = json['RegistrationNo'];
  }
}