class EmploymentTypeModal {
  dynamic state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  List<EmploymentTypeData>? data;

  EmploymentTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  EmploymentTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <EmploymentTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new EmploymentTypeData.fromJson(v));
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

class EmploymentTypeData {
  dynamic dropID;
  dynamic name;

  EmploymentTypeData({this.dropID, this.name});

  EmploymentTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['CommonID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommonID'] = this.dropID;
    data['Name'] = this.name;
    return data;
  }
}
