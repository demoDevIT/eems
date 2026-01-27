class FetchSambalApplicationModal {
  int? state;
  bool? status;
  String? message;
  Null? errorMessage;
  FetchSambalApplicationData? data;

  FetchSambalApplicationModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  FetchSambalApplicationModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new FetchSambalApplicationData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class FetchSambalApplicationData {
  List<FetchSambalApplicationTable>? table;
  List<FetchSambalApplicationTable1>? table1;

  FetchSambalApplicationData({this.table, this.table1});

  FetchSambalApplicationData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <FetchSambalApplicationTable>[];
      json['Table'].forEach((v) {
        table!.add(new FetchSambalApplicationTable.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      table1 = <FetchSambalApplicationTable1>[];
      json['Table1'].forEach((v) {
        table1!.add(new FetchSambalApplicationTable1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table!.map((v) => v.toJson()).toList();
    }
    if (this.table1 != null) {
      data['Table1'] = this.table1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchSambalApplicationTable {
  int? totalCount;

  FetchSambalApplicationTable({this.totalCount});

  FetchSambalApplicationTable.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class FetchSambalApplicationTable1 {
  int? jobSeekerAppliedSchemeId;
  String? applicationNo;
  int? applicationId;
  int? jobSeekerID;
  int? userID;
  String? janAadhaarNo;
  String? janMemberId;
  String? aadharNo;
  String? salutation;
  String? fullName;
  String? fatherName;
  String? dOB;
  String? gender;
  String? mobileNo;
  String? email;
  String? maritalStatus;
  String? category;
  String? schemeName;
  String? eFPONumber;
  String? schemeStatus;
  String? createdOn;
  int? isRequester;
  int? moduleId;
  int? subModuleId;
  int? appWorkflowId;
  int? schemeID;
  String? refTableName;
  int? isEarliestRows;

  FetchSambalApplicationTable1(
      {this.jobSeekerAppliedSchemeId,
        this.applicationNo,
        this.applicationId,
        this.jobSeekerID,
        this.userID,
        this.janAadhaarNo,
        this.janMemberId,
        this.aadharNo,
        this.salutation,
        this.fullName,
        this.fatherName,
        this.dOB,
        this.gender,
        this.mobileNo,
        this.email,
        this.maritalStatus,
        this.category,
        this.schemeName,
        this.eFPONumber,
        this.schemeStatus,
        this.createdOn,
        this.isRequester,
        this.moduleId,
        this.subModuleId,
        this.appWorkflowId,
        this.schemeID,
        this.refTableName,
        this.isEarliestRows});

  FetchSambalApplicationTable1.fromJson(Map<String, dynamic> json) {
    jobSeekerAppliedSchemeId = json['JobSeekerAppliedSchemeId'];
    applicationNo = json['ApplicationNo'];
    applicationId = json['ApplicationId'];
    jobSeekerID = json['JobSeekerID'];
    userID = json['UserID'];
    janAadhaarNo = json['JanAadhaarNo'];
    janMemberId = json['JanMemberId'];
    aadharNo = json['AadharNo'];
    salutation = json['Salutation'];
    fullName = json['FullName'];
    fatherName = json['FatherName'];
    dOB = json['DOB'];
    gender = json['Gender'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
    maritalStatus = json['MaritalStatus'];
    category = json['Category'];
    schemeName = json['SchemeName'];
    eFPONumber = json['EFPONumber'];
    schemeStatus = json['SchemeStatus'];
    createdOn = json['CreatedOn'];
    isRequester = json['IsRequester'];
    moduleId = json['ModuleId'];
    subModuleId = json['SubModuleId'];
    appWorkflowId = json['AppWorkflowId'];
    schemeID = json['SchemeID'];
    refTableName = json['RefTableName'];
    isEarliestRows = json['IsEarliestRows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobSeekerAppliedSchemeId'] = this.jobSeekerAppliedSchemeId;
    data['ApplicationNo'] = this.applicationNo;
    data['ApplicationId'] = this.applicationId;
    data['JobSeekerID'] = this.jobSeekerID;
    data['UserID'] = this.userID;
    data['JanAadhaarNo'] = this.janAadhaarNo;
    data['JanMemberId'] = this.janMemberId;
    data['AadharNo'] = this.aadharNo;
    data['Salutation'] = this.salutation;
    data['FullName'] = this.fullName;
    data['FatherName'] = this.fatherName;
    data['DOB'] = this.dOB;
    data['Gender'] = this.gender;
    data['MobileNo'] = this.mobileNo;
    data['Email'] = this.email;
    data['MaritalStatus'] = this.maritalStatus;
    data['Category'] = this.category;
    data['SchemeName'] = this.schemeName;
    data['EFPONumber'] = this.eFPONumber;
    data['SchemeStatus'] = this.schemeStatus;
    data['CreatedOn'] = this.createdOn;
    data['IsRequester'] = this.isRequester;
    data['ModuleId'] = this.moduleId;
    data['SubModuleId'] = this.subModuleId;
    data['AppWorkflowId'] = this.appWorkflowId;
    data['SchemeID'] = this.schemeID;
    data['RefTableName'] = this.refTableName;
    data['IsEarliestRows'] = this.isEarliestRows;
    return data;
  }
}
