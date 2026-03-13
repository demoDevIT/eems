class GetEducationTypeModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<GetEducationTypeData>? data;

  GetEducationTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GetEducationTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GetEducationTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new GetEducationTypeData.fromJson(v));
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

class GetEducationTypeData {
  dynamic dropID;
  dynamic name;
  dynamic nameHIN;

  GetEducationTypeData({this.dropID, this.name, this.nameHIN});

  GetEducationTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['QualificationID'];
    name = json['Qualification_ENG'];
    nameHIN = json['Qualification_HI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QualificationID'] = this.dropID;
    data['Qualification_ENG'] = this.name;
    data['Qualification_HI'] = this.nameHIN;
    return data;
  }
}
