class EmpTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<EmpTypeData>? data;

  EmpTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  EmpTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <EmpTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new EmpTypeData.fromJson(v));
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

class EmpTypeData {
  int? dropID;
  String? name;
  String? nameHi;
  String? type;

  EmpTypeData({this.dropID, this.name, this.nameHi, this.type});

  EmpTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['CommonID'];
    name = json['Name'];
    nameHi = json['Name_HI'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommonID'] = this.dropID;
    data['Name'] = this.name;
    data['Name_HI'] = this.nameHi;
    data['Type'] = this.type;
    return data;
  }
}
