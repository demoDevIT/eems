class DisabilityTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DisabilityTypeData>? data;

  DisabilityTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  DisabilityTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DisabilityTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new DisabilityTypeData.fromJson(v));
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

class DisabilityTypeData {
  int? dropID;
  String? name;

  DisabilityTypeData({this.dropID, this.name});

  DisabilityTypeData.fromJson(Map<String, dynamic> json) {
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
