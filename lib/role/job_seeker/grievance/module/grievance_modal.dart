class GrievanceModal {
  dynamic state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  List<GrievanceModalData>? data;

  GrievanceModal({this.state, this.status, this.message, this.errorMessage, this.data});

  GrievanceModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GrievanceModalData>[];
      json['Data'].forEach((v) {
        data!.add(new GrievanceModalData.fromJson(v));
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

class GrievanceModalData {
  dynamic grievanceID;
  dynamic complainNo;
  dynamic subject;
  dynamic remark;
  dynamic statusID;
  dynamic createdDate;
  dynamic fileAttachment;
  dynamic disAttachmentFileName;
  dynamic categoryID;
  dynamic categoryType;
  dynamic moduleID;
  dynamic subModuleID;
  dynamic moduleNameEn;
  dynamic subModuleNameEn;
  dynamic createdBy;
  dynamic roleID;
  dynamic departmentID;
  dynamic grievanceApplier;
  dynamic feedbackDone;

  GrievanceModalData(
      {this.grievanceID,
        this.complainNo,
        this.subject,
        this.remark,
        this.statusID,
        this.createdDate,
        this.fileAttachment,
        this.disAttachmentFileName,
        this.categoryID,
        this.categoryType,
        this.moduleID,
        this.subModuleID,
        this.moduleNameEn,
        this.subModuleNameEn,
        this.createdBy,
        this.roleID,
        this.departmentID,
        this.grievanceApplier,
        this.feedbackDone});

  GrievanceModalData.fromJson(Map<String, dynamic> json) {
    grievanceID = json['GrievanceID'];
    complainNo = json['ComplainNo'];
    subject = json['Subject'];
    remark = json['Remark'];
    statusID = json['StatusID'];
    createdDate = json['CreatedDate'];
    fileAttachment = json['FileAttachment'];
    disAttachmentFileName = json['DisAttachmentFileName'];
    categoryID = json['CategoryID'];
    categoryType = json['CategoryType'];
    moduleID = json['ModuleID'];
    subModuleID = json['SubModuleID'];
    moduleNameEn = json['ModuleNameEn'];
    subModuleNameEn = json['SubModuleNameEn'];
    createdBy = json['CreatedBy'];
    roleID = json['RoleID'];
    departmentID = json['DepartmentID'];
    grievanceApplier = json['GrievanceApplier'];
    feedbackDone = json['FeedbackDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GrievanceID'] = this.grievanceID;
    data['ComplainNo'] = this.complainNo;
    data['Subject'] = this.subject;
    data['Remark'] = this.remark;
    data['StatusID'] = this.statusID;
    data['CreatedDate'] = this.createdDate;
    data['FileAttachment'] = this.fileAttachment;
    data['DisAttachmentFileName'] = this.disAttachmentFileName;
    data['CategoryID'] = this.categoryID;
    data['CategoryType'] = this.categoryType;
    data['ModuleID'] = this.moduleID;
    data['SubModuleID'] = this.subModuleID;
    data['ModuleNameEn'] = this.moduleNameEn;
    data['SubModuleNameEn'] = this.subModuleNameEn;
    data['CreatedBy'] = this.createdBy;
    data['RoleID'] = this.roleID;
    data['DepartmentID'] = this.departmentID;
    data['GrievanceApplier'] = this.grievanceApplier;
    data['FeedbackDone'] = this.feedbackDone;
    return data;
  }
}
