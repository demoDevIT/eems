class SalaryRangeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<SalaryRangeData>? data;

  SalaryRangeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  SalaryRangeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <SalaryRangeData>[];
      json['Data'].forEach((v) {
        data!.add(new SalaryRangeData.fromJson(v));
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

class SalaryRangeData {
  int? dropID;
  String? name;
  String? code;
  String? unit;
  String? qty;
  int? typeID;

  SalaryRangeData({this.dropID, this.name, this.code, this.unit, this.qty, this.typeID});

  SalaryRangeData.fromJson(Map<String, dynamic> json) {
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
