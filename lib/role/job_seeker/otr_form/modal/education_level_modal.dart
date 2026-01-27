class EducationLevelModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<EducationLevelData>? data;

  EducationLevelModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  EducationLevelModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <EducationLevelData>[];
      json['Data'].forEach((v) {
        data!.add(new EducationLevelData.fromJson(v));
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

class EducationLevelData {
  int? dropID;
  String? name;
  String? qualificationHI;

  EducationLevelData({this.dropID, this.name, this.qualificationHI});

  EducationLevelData.fromJson(Map<String, dynamic> json) {
    dropID = json['QualificationID'];
    name = json['Qualification_ENG'];
    qualificationHI = json['Qualification_HI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QualificationID'] = this.dropID;
    data['Qualification_ENG'] = this.name;
    data['Qualification_HI'] = this.qualificationHI;
    return data;
  }
}
