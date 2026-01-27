class OTRJanAadharDetailModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<OTRJanAadharDetailData>? data;

  OTRJanAadharDetailModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  OTRJanAadharDetailModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <OTRJanAadharDetailData>[];
      json['Data'].forEach((v) {
        data!.add(new OTRJanAadharDetailData.fromJson(v));
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

class OTRJanAadharDetailData {
  dynamic userId;
  dynamic roleId;
  dynamic registrationNo;
  dynamic response;

  OTRJanAadharDetailData({this.userId, this.roleId, this.registrationNo, this.response});

  OTRJanAadharDetailData.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    registrationNo = json['RegistrationNo'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['RoleId'] = this.roleId;
    data['RegistrationNo'] = this.registrationNo;
    data['Response'] = this.response;
    return data;
  }
}
