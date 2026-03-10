class OfficeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<OfficeData>? data;

  OfficeModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  OfficeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <OfficeData>[];
      json['Data'].forEach((v) {
        data!.add(OfficeData.fromJson(v));
      });
    }
  }
}

class OfficeData {
  int? iD;
  String? nameEng;
  //String? nameHindi;

  OfficeData({
    this.iD,
    this.nameEng,
    //this.nameHindi,
  });

  factory OfficeData.fromJson(Map<String, dynamic> json) {
    return OfficeData(
      iD: json['AllotmentDeptId'],
      nameEng: json['Name_ENG'],
      //nameHindi: json['OfficeNameHi'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfficeData && other.iD == iD;
  }

  @override
  int get hashCode => iD.hashCode;
}
