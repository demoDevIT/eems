class DistrictModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DistrictData>? data;

  DistrictModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  DistrictModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DistrictData>[];
      json['Data'].forEach((v) {
        data!.add(new DistrictData.fromJson(v));
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

class DistrictData {
  int? dISTRICTID;
  String? name;
  int? dIVISIONID;
  String? status;
  int? dropID;

  DistrictData(
      {this.dISTRICTID,
        this.name,
        this.dIVISIONID,
        this.status,
        this.dropID});

  DistrictData.fromJson(Map<String, dynamic> json) {
    dISTRICTID = json['DISTRICT_ID'];
    name = json['DISTRICT_ENG'];
    dIVISIONID = json['DIVISION_ID'];
    status = json['Status'];
    dropID = json['DISTRICT_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DISTRICT_ID'] = this.dISTRICTID;
    data['DISTRICT_ENG'] = this.name;
    data['DIVISION_ID'] = this.dIVISIONID;
    data['Status'] = this.status;
    data['DISTRICT_CODE'] = this.dropID;
    return data;
  }
}
