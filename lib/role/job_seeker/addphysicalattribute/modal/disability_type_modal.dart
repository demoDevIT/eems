class DisabilityTypeModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<DisabilityTypeData>? data;

  DisabilityTypeModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DisabilityTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DisabilityTypeData>[];
      json['Data'].forEach((v) {
        data!.add(DisabilityTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['State'] = state;
    data['Status'] = status;
    data['Message'] = message;
    data['ErrorMessage'] = errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DisabilityTypeData {
  dynamic dropID;
  dynamic name;

  DisabilityTypeData({this.dropID, this.name});

  DisabilityTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['CommonID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['CommonID'] = dropID;
    data['Name'] = name;
    return data;
  }
}
