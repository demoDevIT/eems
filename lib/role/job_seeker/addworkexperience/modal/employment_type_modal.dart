class WorkExpEmploymentTypeModal {
  int? state;
  bool? status;
  String? message;
  Null? errorMessage;
  List<WorkExpEmploymentTypeData>? data;

  WorkExpEmploymentTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  WorkExpEmploymentTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <WorkExpEmploymentTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new WorkExpEmploymentTypeData.fromJson(v));
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

class WorkExpEmploymentTypeData {
  int? dropID;
  String? enumName;
  String? name;
  String? employmentNameHindi;

  WorkExpEmploymentTypeData({this.dropID, this.enumName, this.name, this.employmentNameHindi});

  WorkExpEmploymentTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    enumName = json['EnumName'];
    name = json['Name'];
    employmentNameHindi = json['EmploymentNameHindi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['EnumName'] = this.enumName;
    data['Name'] = this.name;
    data['EmploymentNameHindi'] = this.employmentNameHindi;
    return data;
  }
}
