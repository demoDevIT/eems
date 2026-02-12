class DeptJoinPendingModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptJoinPendingItem>? data;

  DeptJoinPendingModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DeptJoinPendingModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DeptJoinPendingItem>[];
      json['Data'].forEach((v) {
        data!.add(DeptJoinPendingItem.fromJson(v));
      });
    }
  }
}

class DeptJoinPendingItem {
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

  DeptJoinPendingItem({
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

  factory DeptJoinPendingItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinPendingItem(
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
