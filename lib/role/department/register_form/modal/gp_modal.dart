class GramPanchayatModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<GramPanchayatData>? data;

  GramPanchayatModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  GramPanchayatModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <GramPanchayatData>[];
      json['Data'].forEach((v) {
        data!.add(GramPanchayatData.fromJson(v));
      });
    }
  }
}

class GramPanchayatData {
  int? iD;
  String? code;
  String? nameEng;
  String? nameMangal;

  GramPanchayatData({
    this.iD,
    this.code,
    this.nameEng,
    this.nameMangal,
  });

  factory GramPanchayatData.fromJson(Map<String, dynamic> json) {
    return GramPanchayatData(
      iD: json['ID'],
      code: json['CODE'],
      nameEng: json['Name_ENG'],
      nameMangal: json['Name_MANGAL'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GramPanchayatData && other.iD == iD;
  }

  @override
  int get hashCode => iD.hashCode;
}
