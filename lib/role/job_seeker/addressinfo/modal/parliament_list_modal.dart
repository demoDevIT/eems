class ParliamentListModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<ParliamentListData>? data;

  ParliamentListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ParliamentListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ParliamentListData>[];
      json['Data'].forEach((v) {
        data!.add(new ParliamentListData.fromJson(v));
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

class ParliamentListData {
  int? dropID;
  String? name;
  dynamic code;
  dynamic unit;
  dynamic quantity;
  int? typeID;

  ParliamentListData({this.dropID, this.name, this.code, this.unit, this.quantity, this.typeID});

  ParliamentListData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name'];
    code = json['Code'];
    unit = json['Unit'];
    quantity = json['Quantity'];
    typeID = json['TypeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['Unit'] = this.unit;
    data['Quantity'] = this.quantity;
    data['TypeID'] = this.typeID;
    return data;
  }
}
