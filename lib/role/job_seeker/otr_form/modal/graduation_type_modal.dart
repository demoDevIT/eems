class GraduationTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<GraduationTypeData>? data;

  GraduationTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GraduationTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GraduationTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new GraduationTypeData.fromJson(v));
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

class GraduationTypeData {
  int? dropID;
  String? name;

  GraduationTypeData({this.dropID, this.name});

  GraduationTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['QualificationID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QualificationID'] = this.dropID;
    data['Name'] = this.name;
    return data;
  }
}
