class CasteModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CasteData>? data;

  CasteModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  CasteModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <CasteData>[];
      json['Data'].forEach((v) {
        data!.add(CasteData.fromJson(v));
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

class CasteData {
  int? iD;
  String? name;
  String? code;

  CasteData({
    this.iD,
    this.name,
    this.code,
  });

  CasteData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['ID'] = iD;
    json['Name'] = name;
    json['Code'] = code;
    return json;
  }

  // ✅ ADD THIS
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CasteData &&
              runtimeType == other.runtimeType &&
              iD == other.iD;

  // ✅ ADD THIS
  @override
  int get hashCode => iD.hashCode;
}

