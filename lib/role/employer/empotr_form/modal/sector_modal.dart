class SectorModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<SectorData>? data;

  SectorModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  SectorModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <SectorData>[];
      json['Data'].forEach((v) {
        data!.add(SectorData.fromJson(v));
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

class SectorData {
  int? iD;
  String? name;
  String? nameHi;

  SectorData({
    this.iD,
    this.name,
    this.nameHi,
  });

  SectorData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name_ENG'];
    nameHi = json['Name_HI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['ID'] = iD;
    json['Name_ENG'] = name;
    json['Name_HI'] = nameHi;
    return json;
  }

  // ✅ REQUIRED FOR DROPDOWN
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SectorData && other.iD == iD;

  @override
  int get hashCode => iD.hashCode;
}
