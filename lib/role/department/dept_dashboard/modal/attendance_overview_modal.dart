class AttendanceOverviewModal {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<AttendanceOverviewData>? data;

  AttendanceOverviewModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  AttendanceOverviewModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <AttendanceOverviewData>[];
      json['Data'].forEach((v) {
        data!.add(AttendanceOverviewData.fromJson(v));
      });
    }
  }
}

class AttendanceOverviewData {
  int? monthNo;
  String? monthName;
  int? completed;
  int? sendback;
  int? pending;
  int? verified;
  int? totalApplications;
  int? isDashboardVisible;

  AttendanceOverviewData({
    this.monthNo,
    this.monthName,
    this.completed,
    this.sendback,
    this.pending,
    this.verified,
    this.totalApplications,
    this.isDashboardVisible,
  });

  AttendanceOverviewData.fromJson(Map<String, dynamic> json) {
    monthNo = json['MonthNo'];
    monthName = json['MonthName'];
    completed = json['Completed'];
    sendback = json['Sendback'];
    pending = json['Pending'];
    verified = json['Verified'];
    totalApplications = json['TotalApplications'];
    isDashboardVisible = json['IsDashboardVisible'];
  }
}