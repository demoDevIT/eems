class CounselorOTRDetailModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<CounselorOTRDetailData>? data;

  CounselorOTRDetailModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CounselorOTRDetailModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CounselorOTRDetailData>[];
      json['Data'].forEach((v) {
        data!.add(new CounselorOTRDetailData.fromJson(v));
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

class CounselorOTRDetailData {
  dynamic userId;
  dynamic roleId;
  dynamic registrationNo;
  dynamic response;

  CounselorOTRDetailData({this.userId, this.roleId, this.registrationNo, this.response});

  CounselorOTRDetailData.fromJson(Map<String, dynamic> json) {
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
