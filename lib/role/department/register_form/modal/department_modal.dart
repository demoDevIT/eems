class DepartmentModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DepartmentData>? data;

  DepartmentModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DepartmentModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DepartmentData>[];
      json['Data'].forEach((v) {
        data!.add(DepartmentData.fromJson(v));
      });
    }
  }
}

class DepartmentData {
  int? iD;
  String? nameEng;
  String? nameHindi;

  DepartmentData({
    this.iD,
    this.nameEng,
    this.nameHindi,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) {
    return DepartmentData(
      iD: json['ID'],
      nameEng: json['Name_ENG'],
      nameHindi: json['DepartmentNameHi'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DepartmentData && other.iD == iD;
  }

  @override
  int get hashCode => iD.hashCode;
}
