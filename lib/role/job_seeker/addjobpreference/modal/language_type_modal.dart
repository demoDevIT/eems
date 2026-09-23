class LanguageTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<LanguageTypeData>? data;

  LanguageTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  LanguageTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <LanguageTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new LanguageTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LanguageTypeData {
  int? dropID;
  String? name;
  String? nameHi;

  LanguageTypeData({this.dropID, this.name, this.nameHi});

  LanguageTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name_ENG'];
    nameHi = json['Name_HIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['Name_ENG'] = this.name;
    data['Name_HIN'] = this.nameHi;
    return data;
  }
}
