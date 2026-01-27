class ModuleModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ModuleModalData>? data;

  ModuleModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ModuleModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ModuleModalData>[];
      json['Data'].forEach((v) {
        data!.add(new ModuleModalData.fromJson(v));
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

class ModuleModalData {
  dynamic dropID;
  dynamic name;
  dynamic moduleNameHi;

  ModuleModalData({this.dropID, this.name, this.moduleNameHi});

  ModuleModalData.fromJson(Map<String, dynamic> json) {
    dropID = json['ModuleId'];
    name = json['ModuleNameEn'];
    moduleNameHi = json['ModuleNameHi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModuleId'] = this.dropID;
    data['ModuleNameEn'] = this.name;
    data['ModuleNameHi'] = this.moduleNameHi;
    return data;
  }
}
