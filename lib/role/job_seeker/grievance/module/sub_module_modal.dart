class SubModuleModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<SubModuleData>? data;

  SubModuleModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  SubModuleModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <SubModuleData>[];
      json['Data'].forEach((v) {
        data!.add(new SubModuleData.fromJson(v));
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

class SubModuleData {
  int? moduleId;
  int? dropID;
  String? name;
  dynamic subModuleNameHi;

  SubModuleData(
      {this.moduleId,
        this.dropID,
        this.name,
        this.subModuleNameHi});

  SubModuleData.fromJson(Map<String, dynamic> json) {
    moduleId = json['ModuleId'];
    dropID = json['SubModuleId'];
    name = json['SubModuleNameEn'];
    subModuleNameHi = json['SubModuleNameHi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModuleId'] = this.moduleId;
    data['SubModuleId'] = this.dropID;
    data['SubModuleNameEn'] = this.name;
    data['SubModuleNameHi'] = this.subModuleNameHi;
    return data;
  }
}
