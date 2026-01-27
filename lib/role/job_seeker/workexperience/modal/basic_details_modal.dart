class BasicDetailsModal {
  int? state;
  bool? status;
  String? message;
  List<BasicDetailsData>? data;

  BasicDetailsModal({this.state, this.status, this.message, this.data});

  factory BasicDetailsModal.fromJson(Map<String, dynamic> json) {
    return BasicDetailsModal(
      state: json['State'],
      status: json['Status'],
      message: json['Message'],
      data: json['Data'] != null
          ? (json['Data'] as List)
          .map((e) => BasicDetailsData.fromJson(e))
          .toList()
          : [],
    );
  }
}

class BasicDetailsData {
  String? employmentStatus;
  int? employmentExpYear;
  int? employmentExpMonth;

  BasicDetailsData({
    this.employmentStatus,
    this.employmentExpYear,
    this.employmentExpMonth,
  });

  factory BasicDetailsData.fromJson(Map<String, dynamic> json) {
    return BasicDetailsData(
      employmentStatus: json['EmploymentStatus'],
      employmentExpYear: json['EmploymentExpYear'],
      employmentExpMonth: json['EmploymentExpMonth'],
    );
  }
}
