class AttendanceTrailModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<AttendanceTrailData>? data;

  AttendanceTrailModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  AttendanceTrailModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <AttendanceTrailData>[];

      json['Data'].forEach((v) {
        data!.add(AttendanceTrailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['State'] = state;
    data['Status'] = status;
    data['Message'] = message;
    data['ErrorMessage'] = errorMessage;

    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class AttendanceTrailData {
  int? srNo;
  int? id;
  int? jobSeekerID;
  String? registrationNo;
  String? lastLetter;
  String? attendanceMonth;
  String? actionBy;
  String? currentStatus;
  String? joiningDate;
  String? remarks;
  String? createDate;
  String? actionDate;
  String? workingYear;

  AttendanceTrailData({
    this.srNo,
    this.id,
    this.jobSeekerID,
    this.registrationNo,
    this.lastLetter,
    this.attendanceMonth,
    this.actionBy,
    this.currentStatus,
    this.joiningDate,
    this.remarks,
    this.createDate,
    this.actionDate,
    this.workingYear,
  });

  AttendanceTrailData.fromJson(Map<String, dynamic> json) {
    srNo = json['SRNO'];
    id = json['ID'];
    jobSeekerID = json['JobSeekerID'];
    registrationNo = json['RegistrationNo'];
    lastLetter = json['LastLetter'];
    attendanceMonth = json['AttendanceMonth'];
    actionBy = json['ActionBy'];
    currentStatus = json['CurrentStatus'];
    joiningDate = json['JoiningDate'];
    remarks = json['Remarks'];
    createDate = json['CreateDate'];
    actionDate = json['ActionDate'];
    workingYear = json['WorkingYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['SRNO'] = srNo;
    data['ID'] = id;
    data['JobSeekerID'] = jobSeekerID;
    data['RegistrationNo'] = registrationNo;
    data['LastLetter'] = lastLetter;
    data['AttendanceMonth'] = attendanceMonth;
    data['ActionBy'] = actionBy;
    data['CurrentStatus'] = currentStatus;
    data['JoiningDate'] = joiningDate;
    data['Remarks'] = remarks;
    data['CreateDate'] = createDate;
    data['ActionDate'] = actionDate;
    data['WorkingYear'] = workingYear;

    return data;
  }
}