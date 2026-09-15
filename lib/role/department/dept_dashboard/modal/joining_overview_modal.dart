class JoiningOverviewModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<JoiningOverviewData>? data;

  JoiningOverviewModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  JoiningOverviewModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <JoiningOverviewData>[];

      json['Data'].forEach((v) {
        data!.add(JoiningOverviewData.fromJson(v));
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

class JoiningOverviewData {
  int? totalApplications;
  int? completed;
  int? pending;

  JoiningOverviewData({
    this.totalApplications,
    this.completed,
    this.pending,
  });

  JoiningOverviewData.fromJson(Map<String, dynamic> json) {
    totalApplications = json['TotalApplications'];
    completed = json['Completed'];
    pending = json['Pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['TotalApplications'] = totalApplications;
    data['Completed'] = completed;
    data['Pending'] = pending;

    return data;
  }
}