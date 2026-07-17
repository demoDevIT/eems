class MysyListModel {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<MysyData>? data;

  MysyListModel({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  MysyListModel.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];

    data = [];

    if (json['Data'] != null) {
      final dataJson = json['Data'];

      final table1 = dataJson['Table1'] as List? ?? [];

      for (var app in table1) {
        data!.add(
          MysyData(
            applicationInfo: ApplicationInfo.fromJson(app),

            allottedDepartments:
            (dataJson['Table2'] as List? ?? [])
                .map((e) => AllottedDepartment.fromJson(e))
                .toList(),

            joiningLogs:
            (dataJson['Table3'] as List? ?? [])
                .map((e) => JoiningLog.fromJson(e))
                .toList(),

            paymentLogs:
            (dataJson['Table4'] as List? ?? [])
                .map((e) => PaymentLog.fromJson(e))
                .toList(),

            attendanceLogs:
            (dataJson['Table5'] as List? ?? [])
                .map((e) => AttendanceLog.fromJson(e))
                .toList(),

            messageLogs:
            (dataJson['Table6'] as List? ?? [])
                .map((e) => MessageLog.fromJson(e))
                .toList(),

            documentLogs:
            (dataJson['Table7'] as List? ?? [])
                .map((e) => DocumentLog.fromJson(e))
                .toList(),
          ),
        );
      }
    }
  }
}

class MysyData {
  ApplicationInfo? applicationInfo;

  List<AllottedDepartment> allottedDepartments;
  List<JoiningLog> joiningLogs;
  List<PaymentLog> paymentLogs;
  List<AttendanceLog> attendanceLogs;
  List<MessageLog> messageLogs;
  List<DocumentLog> documentLogs;

  MysyData({
    this.applicationInfo,
    this.allottedDepartments = const [],
    this.joiningLogs = const [],
    this.paymentLogs = const [],
    this.attendanceLogs = const [],
    this.messageLogs = const [],
    this.documentLogs = const [],
  });

  factory MysyData.fromJson(Map<String, dynamic> json) {
    return MysyData(
      applicationInfo: ApplicationInfo.fromJson(json),
    );
  }
}

class ApplicationInfo {
  int? applicationId;
  String? applicationNo;
  String? fullName;
  String? fatherName;
  String? aadharNo;
  String? gender;
  String? category;
  String? dob;
  String? schemeName;
  String? schemeStatus;
  String? createdOn;
  String? latestPhoto;
  String? mobileNo;
  String? regDate;
  String? applyDate;
  String? approveDate;
  String? stopDate;


  ApplicationInfo.fromJson(Map<String, dynamic> json) {
    applicationId = json['ApplicationId'];
    applicationNo = json['ApplicationNo'];
    fullName = json['FullName'];
    fatherName = json['FatherName'];
    aadharNo = json['AadharNo'];
    gender = json['Gender'];
    category = json['Category'];
    dob = json['DOB'];
    schemeName = json['SchemeName'];
    schemeStatus = json['SchemeStatus'];
    createdOn = json['CreatedOn'];
    latestPhoto = json['LatestPhoto'];
    mobileNo = json['MobileNo'];
    regDate = json['RegistrationDate'];
    applyDate = json['ApplyDate_DDMMYYYY'];
    approveDate = json['ApproveDate_DDMMYYYY'];
    stopDate = json['StopedDate_DDMMYYYY'];
  }
}

class AllottedDepartment {
  String? deptName;
  String? allotDeptName;
  String? deptAllotDate;
  String? joiningDate;
  String? joiningLetter;

  AllottedDepartment.fromJson(Map<String, dynamic> json) {
    deptName = json['deptname'];
    allotDeptName = json['AllotDeptName'];
    deptAllotDate = json['DeptAllotDate'];
    joiningDate = json['JoiningDate'];
    joiningLetter = json['JoiningLetter'];
  }
}

class JoiningLog {
  int? srNo;
  String? regNo;
  String? lastLetter;
  String? currentStatus;
  String? joiningDate;
  String? remarks;
  String? actionDate;

  JoiningLog.fromJson(Map<String, dynamic> json) {
    srNo = json['SRNO'];
    regNo = json['RegistrationNo'];
    lastLetter = json['LastLetter'];
    currentStatus = json['CurrentStatus'];
    joiningDate = json['JoiningDate'];
    remarks = json['Remarks'];
    actionDate = json['ActionDate'];
  }
}

class PaymentLog {
  int? paymentOrder;
  int? id;
  String? jobSeekerName;
  int? submittedMonth;
  String? paymentMonthYear;
  double? amount;
  int? JobSeekerId;

  PaymentLog.fromJson(Map<String, dynamic> json) {
    paymentOrder = json['PaymentOrder'];
    id = json['ID'];
    jobSeekerName = json['Job_SeekerName'];
    submittedMonth = json['SubmittedMonth'];
    paymentMonthYear = json['PaymentMonthYear'];
    amount = (json['Amount'] as num?)?.toDouble();
    JobSeekerId = json['JobSeeker_ID'];
  }
}

class AttendanceLog {
  int? srNo;
  String? attendanceMonthYear;
  String? currentStatus;
  String? joiningDate;
  String? remarks;
  String? actionDate;
  String? lastUploadedLetter;

  AttendanceLog.fromJson(Map<String, dynamic> json) {
    srNo = json['SRNO'];
    attendanceMonthYear = json['AttendanceMonthYear'];
    currentStatus = json['CurrentStatus'];
    joiningDate = json['JoiningDate'];
    remarks = json['Remarks'];
    actionDate = json['ActionDate'];
    lastUploadedLetter = json['LastUploadedLetter'];
  }
}

class MessageLog {
  String? sentOn;
  String? applicationStatus;
  String? message;

  MessageLog.fromJson(Map<String, dynamic> json) {
    sentOn = json['SentOn'];
    applicationStatus = json['ApplicationStatus'];
    message = json['Message'];
  }
}

class DocumentLog {
  String? RegNo;
  String? DocName;
  String? ReveretDoc;
  String? RevertMsg;
  String? actionBy;
  String? revertedDate;

  DocumentLog.fromJson(Map<String, dynamic> json) {
    RegNo = json['RegistrationNo'];
    DocName = json['DocumentName'];
    ReveretDoc = json['ReveredDocument'];
    RevertMsg = json['RecvertMessage'];
    actionBy = json['ActionBy'];
    revertedDate = json['RevertedDate'];
  }
}