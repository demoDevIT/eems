class VillageModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<VillageData>? data;

  VillageModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  VillageModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <VillageData>[];
      json['Data'].forEach((v) {
        data!.add(VillageData.fromJson(v));
      });
    }
  }
}

class VillageData {
  int? iD;
  String? code;
  String? nameEng;
  String? nameMangal;

  VillageData({
    this.iD,
    this.code,
    this.nameEng,
    this.nameMangal,
  });

  factory VillageData.fromJson(Map<String, dynamic> json) {
    return VillageData(
      iD: json['ID'],
      code: json['CODE'],
      nameEng: json['Name_ENG'],
      nameMangal: json['Name_MANGAL'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VillageData && other.iD == iD;
  }

  @override
  int get hashCode => iD.hashCode;
}
