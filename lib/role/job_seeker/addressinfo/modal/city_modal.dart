class CityModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CityData>? data;

  CityModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CityModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CityData>[];
      json['Data'].forEach((v) {
        data!.add(new CityData.fromJson(v));
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

class CityData {
  int? iD;
  dynamic lGCODE;
  String? dropID;
  String? name;
  String? nameMANGAL;

  CityData({this.iD, this.lGCODE, this.dropID, this.name, this.nameMANGAL});

  CityData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    lGCODE = json['LGCODE'];
    dropID = json['CODE'];
    name = json['Name_ENG'];
    nameMANGAL = json['Name_MANGAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['LGCODE'] = this.lGCODE;
    data['CODE'] = this.dropID;
    data['Name_ENG'] = this.name;
    data['Name_MANGAL'] = this.nameMANGAL;
    return data;
  }
}
