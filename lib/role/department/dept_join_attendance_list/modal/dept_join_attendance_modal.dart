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
  String? applicationNo;
  String? name;
  String? fatherName;
  String? schemeName;
  String? aadharNo;
  String? gender;
  String? category;
  String? schemeStatus;
  String? allotmentDate;
  String? technicalCourse;

  DeptJoinAttendanceItem({
    this.jobseekerUserId,
    this.applicationNo,
    this.name,
    this.fatherName,
    this.schemeName,
    this.aadharNo,
    this.gender,
    this.category,
    this.schemeStatus,
    this.allotmentDate,
    this.technicalCourse,
  });

  factory DeptJoinAttendanceItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinAttendanceItem(
      jobseekerUserId: json['JobseekerUserID']?.toString(),
      applicationNo: json['ApplicationNo'],
      name: json['JobseekerName'],
      fatherName: json['FatherName'],
      schemeName: json['SchemeName'],
      aadharNo: json['AadharNo'],
      gender: json['Gender'],
      category: json['Category'],
      schemeStatus: json['SchemeStatus'],
      allotmentDate: json['CreatedOn'],
      technicalCourse: json['TechnicalCourse'], // shown as Exchange Name
    );
  }
}
