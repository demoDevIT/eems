class OTREmpDetailModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<OTREmpDetailData>? data;

  OTREmpDetailModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  OTREmpDetailModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <OTREmpDetailData>[];
      json['Data'].forEach((v) {
        data!.add(OTREmpDetailData.fromJson(v));
      });
    }
  }
}

class OTREmpDetailData {
  dynamic userId;
  dynamic roleId;
  dynamic registrationNumber;
  dynamic mobile;
  dynamic branchName;

  OTREmpDetailData({
    this.userId,
    this.roleId,
    this.registrationNumber,
    this.mobile,
    this.branchName,
  });

  OTREmpDetailData.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    registrationNumber = json['RegistrationNumber'];
    mobile = json['Mobile'];
    branchName = json['BranchName'];
  }
}
