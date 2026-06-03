class CityModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CityData>? data;

  CityModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  CityModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <CityData>[];
      json['Data'].forEach((v) {
        data!.add(CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['State'] = state;
    json['Status'] = status;
    json['Message'] = message;
    json['ErrorMessage'] = errorMessage;
    if (data != null) {
      json['Data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class CityData {
  int? iD;
  String? code;
  String? nameEng;
  String? nameMangal;

  CityData({
    this.iD,
    this.code,
    this.nameEng,
    this.nameMangal,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      iD: json['ID'],
      code: json['CODE'],
      nameEng: json['Name_ENG'],
      nameMangal: json['Name_MANGAL'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['ID'] = iD;
    json['CODE'] = code;
    json['Name_ENG'] = nameEng;
    json['Name_MANGAL'] = nameMangal;
    return json;
  }

  // ✅ IMPORTANT for Dropdown selection
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CityData && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
