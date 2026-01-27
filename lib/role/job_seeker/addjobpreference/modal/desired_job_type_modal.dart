class DesiredJobTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DesiredJobTypeData>? data;

  DesiredJobTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  DesiredJobTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DesiredJobTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new DesiredJobTypeData.fromJson(v));
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

class DesiredJobTypeData {
  int? dropID;
  String? name;

  DesiredJobTypeData({this.dropID, this.name});

  DesiredJobTypeData.fromJson(Map<String, dynamic> json) {
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
