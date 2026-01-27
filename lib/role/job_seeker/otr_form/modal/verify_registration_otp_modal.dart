class VerifyRegistrationOtpModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<VerifyRegistrationOtpData>? data;

  VerifyRegistrationOtpModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  VerifyRegistrationOtpModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <VerifyRegistrationOtpData>[];
      json['Data'].forEach((v) {
        data!.add(new VerifyRegistrationOtpData.fromJson(v));
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

class VerifyRegistrationOtpData {
  dynamic res;

  VerifyRegistrationOtpData({this.res});

  VerifyRegistrationOtpData.fromJson(Map<String, dynamic> json) {
    res = json['res'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    return data;
  }
}
