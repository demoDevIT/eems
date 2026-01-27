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
  String? nameENG1;

  LanguageTypeData({this.dropID, this.name, this.nameENG1});

  LanguageTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name_ENG'];
    nameENG1 = json['Name_ENG1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['Name_ENG'] = this.name;
    data['Name_ENG1'] = this.nameENG1;
    return data;
  }
}
