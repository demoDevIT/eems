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
        data!.add(SalaryRangeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['State'] = state;
    data['Status'] = status;
    data['Message'] = message;
    data['ErrorMessage'] = errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SalaryRangeData {
  int? dropID;        // 👈 REQUIRED by dropdown
  String? name;       // display text
  int? enumValue;     // keep for API save

  SalaryRangeData({this.dropID, this.name, this.enumValue});

  SalaryRangeData.fromJson(Map<String, dynamic> json) {
    dropID = json['EnumValue'];   // 🔥 KEY FIX
    name = json['Name'];
    enumValue = json['EnumValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['EnumValue'] = enumValue;
    data['Name'] = name;
    return data;
  }
}


