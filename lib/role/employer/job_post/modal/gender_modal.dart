class GenderModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<GenderData>? data;

  GenderModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GenderModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GenderData>[];
      json['Data'].forEach((v) {
        data!.add(new GenderData.fromJson(v));
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

class GenderData {
  int? dropID;
  String? name;
  String? code;
  String? unit;
  String? qty;
  int? typeID;

  GenderData({this.dropID, this.name, this.code, this.unit, this.qty, this.typeID});

  GenderData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name'];
    code = json['Code'];
    unit = json['Unit'];
    qty = json['Quantity'];
    typeID = json['TypeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['Unit'] = this.unit;
    data['Quantity'] = this.qty;
    data['TypeID'] = this.typeID;
    return data;
  }
}
