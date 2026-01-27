class AcquiredTypeModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List< AcquiredTypeData>? data;

  AcquiredTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  AcquiredTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = < AcquiredTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new  AcquiredTypeData.fromJson(v));
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

class  AcquiredTypeData {
  dynamic dropID;
  dynamic name;

  AcquiredTypeData({this.dropID, this.name});

  AcquiredTypeData.fromJson(Map<String, dynamic> json) {
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
