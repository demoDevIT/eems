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
  String? allotmentDate;
  String? exchangeName;

  DeptJoinAttendanceItem({
    this.jobseekerUserId,
    this.applicationNo,
    this.name,
    this.fatherName,
    this.allotmentDate,
    this.exchangeName,
  });

  factory DeptJoinAttendanceItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinAttendanceItem(
      jobseekerUserId: json['JobseekerUserID']?.toString(),
      applicationNo: json['ApplicationNo'],
      name: json['JobseekerName'],
      fatherName: json['FatherName'],
      allotmentDate: json['CreatedOn'],
      exchangeName: json['SchemeName'], // shown as Exchange Name
    );
  }
}
