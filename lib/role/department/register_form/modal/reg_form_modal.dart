class RegFormModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<RegFormData>? data;

  RegFormModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  RegFormModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <RegFormData>[];
      json['Data'].forEach((v) {
        data!.add(RegFormData.fromJson(v));
      });
    }
  }
}

class RegFormData {
  dynamic userId;
  dynamic roleId;
  dynamic isApprove;
  dynamic resMsg;
  // dynamic registrationNumber;
  // dynamic mobile;
  // dynamic branchName;

  RegFormData({
    this.userId,
    this.roleId,
    this.isApprove,
    this.resMsg,
    // this.registrationNumber,
    // this.mobile,
    // this.branchName,
  });

  RegFormData.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    isApprove = json['IsApproved'];
    resMsg = json['ResponseMessage'];
    // registrationNumber = json['RegistrationNumber'];
    // mobile = json['Mobile'];
    // branchName = json['BranchName'];
  }
}
