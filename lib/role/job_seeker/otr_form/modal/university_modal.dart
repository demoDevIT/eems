class UniversityModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<UniversityData>? data;

  UniversityModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  UniversityModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <UniversityData>[];
      json['Data'].forEach((v) {
        data!.add(new UniversityData.fromJson(v));
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

class UniversityData {
  int? dropID;
  String? name;
  String? universityNameHin;

  UniversityData({this.dropID, this.name, this.universityNameHin});

  UniversityData.fromJson(Map<String, dynamic> json) {
    dropID = json['UniversityId'];
    name = json['UniversityNameENG'];
    universityNameHin = json['UniversityNameHin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UniversityId'] = this.dropID;
    data['UniversityNameENG'] = this.name;
    data['UniversityNameHin'] = this.universityNameHin;
    return data;
  }
}
