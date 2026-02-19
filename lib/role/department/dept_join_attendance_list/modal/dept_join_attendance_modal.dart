class DeptJoinAttendanceModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptJoinAttendanceItem>? data;

  DeptJoinAttendanceModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DeptJoinAttendanceModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DeptJoinAttendanceItem>[];
      json['Data'].forEach((v) {
        data!.add(DeptJoinAttendanceItem.fromJson(v));
      });
    }
  }
}

class DeptJoinAttendanceItem {
    String? jobseekerUserId;
    String? jobSeekerID;
    String? nameEng;
    String? fatherNameEng;
    String? mobileNo;
    String? ssoid;
    String? privateDistrictCode;
    int? joiningID;
    String? officeName;
    String? registrationNo;
    String? departmentNameEn;
    String? internJoiningDate;
    int? workingYear;
    int? attendanceMonthId;
    String? attendanceMonthName;
    String? yearMonth;
    String? address;
    String? districtEn;
    String? assembly;
    int? attendanceMarkStatus;

  DeptJoinAttendanceItem({
    this.jobseekerUserId,
    this.jobSeekerID,
    this.nameEng,
    this.fatherNameEng,
    this.mobileNo,
    this.ssoid,
    this.privateDistrictCode,
    this.joiningID,
    this.officeName,
    this.registrationNo,
    this.departmentNameEn,
    this.internJoiningDate,
    this.workingYear,
    this.attendanceMonthId,
    this.attendanceMonthName,
    this.yearMonth,
    this.address,
    this.districtEn,
    this.assembly,
    this.attendanceMarkStatus
  });

  factory DeptJoinAttendanceItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinAttendanceItem(
      jobseekerUserId: json['JobSeekerUserId']?.toString(),
      jobSeekerID: json['JobSeekerID']?.toString(),
      nameEng: json['NAME_ENG'],
      fatherNameEng: json['FATHER_NAME_ENG'],
      mobileNo: json['MOBILE_NO'],
      ssoid: json['DepartmentSSOID'],
      privateDistrictCode: json['PrivateDistrictCode'],
      joiningID: json['JoiningID'],
      officeName: json['OfficeName'],
      registrationNo: json['RegistrationNo'],
      departmentNameEn: json['DepartmentNameEn'],
      internJoiningDate: json['InternJoiningDate'],
      workingYear: json['WorkingYear'],
      attendanceMonthId: json['AttendanceMonthId'],
      attendanceMonthName: json['AttendanceMonthName'],
      yearMonth: json['YearMonth'], // shown as Exchange Name
      address: json['Address'],
      districtEn: json['DistrictEn'],
      assembly: json['Assembly'],
      attendanceMarkStatus: json['AttendanceMarkStatus'],
    );
  }
}
