class WardModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<WardData>? data;

  WardModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  WardModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <WardData>[];
      json['Data'].forEach((v) {
        data!.add(WardData.fromJson(v));
      });
    }
  }
}

class WardData {
  int? iD;
  String? code;
  String? nameEng;
  String? nameMangal;

  WardData({
    this.iD,
    this.code,
    this.nameEng,
    this.nameMangal,
  });

  factory WardData.fromJson(Map<String, dynamic> json) {
    return WardData(
      iD: json['ID'],
      code: json['CODE'],
      nameEng: json['Name_ENG'],
      nameMangal: json['Name_MANGAL'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WardData && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
