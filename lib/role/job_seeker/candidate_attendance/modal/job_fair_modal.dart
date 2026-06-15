class JobFairModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<JobFairData>? data;

  JobFairModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobFairModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobFairData>[];
      json['Data'].forEach((v) {
        data!.add(new JobFairData.fromJson(v));
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

class JobFairData {
  dynamic profileID;
  dynamic userID;
  dynamic roleID;
  dynamic ssoID;
  dynamic districtCode;
  dynamic displayName;
  dynamic mobileno;
  dynamic mailPersonal;
  dynamic mailOfficial;
  dynamic designation;
  dynamic departmentName;
  dynamic empNumber;
  dynamic deptID;
  dynamic firstName;
  dynamic lastName;
  dynamic janaadhaarId;
  dynamic userType;
  dynamic eng_NonEng;
  dynamic eng_NonEngName;
  dynamic finYearID;
  dynamic userReqStatus;
  dynamic loginStatus;
  dynamic officeID;
  dynamic encrypted_SSOID;
  dynamic searchRecordID;
  dynamic SSOTOKEN;
  dynamic internDeptID;
  dynamic internDeptTypeID;
  dynamic nameAsJanAdhar;
  dynamic districtEn;
  dynamic gender;
  dynamic postalAddress;
  dynamic aadhaarId;

  JobFairData(
      {this.profileID,
        this.userID,
        this.roleID,
        this.ssoID,
        this.districtCode,
        this.displayName,
        this.mobileno,
        this.mailPersonal,
        this.mailOfficial,
        this.designation,
        this.departmentName,
        this.empNumber,
        this.deptID,
        this.firstName,
        this.lastName,
        this.janaadhaarId,
        this.userType,
        this.eng_NonEng,
        this.eng_NonEngName,
        this.finYearID,
        this.userReqStatus,
        this.loginStatus,
        this.officeID,
        this.encrypted_SSOID,
        this.searchRecordID,
        this.SSOTOKEN,
        this.internDeptID,
        this.internDeptTypeID,
        this.nameAsJanAdhar,
        this.districtEn,
        this.gender,
        this.postalAddress,
        this.aadhaarId
      });

  JobFairData.fromJson(Map<String, dynamic> json) {
    profileID = json['ProfileID'];
    userID = json['UserID'];
    roleID = json['RoleID'];
    ssoID = json['SSOID'];
    districtCode = json['DistrictCode'];
    displayName = json['DisplayName'];
    mobileno = json['Mobileno'];
    mailPersonal = json['MailPersonal'];
    mailOfficial = json['MailOfficial'];
    designation = json['Designation'];
    departmentName = json['DepartmentName'];
    empNumber = json['EmployeeNumber'];
    deptID = json['DepartmentID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    janaadhaarId = json['JanaadhaarId'];
    userType = json['UserType'];
    eng_NonEng = json['Eng_NonEng'];
    eng_NonEngName = json['Eng_NonEngName'];
    finYearID = json['FinancialYearID'];
    userReqStatus = json['UserRequestStatus'];
    loginStatus = json['LoginStatus'];
    officeID = json['OfficeID'];
    encrypted_SSOID = json['Encrypted_SSOID'];
    searchRecordID = json['SearchRecordID'];
    SSOTOKEN = json['SSOTOKEN'];
    internDeptID = json['InternshipDeptID'];
    internDeptTypeID = json['InternshipDeptTypeID'];
    nameAsJanAdhar = json['NameAsjanAdhar'];
    districtEn = json['DistrictEn'];
    gender = json['Gender'];
    postalAddress = json['postalAddress'];
    aadhaarId = json['aadhaarId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProfileID'] = this.profileID;
    data['UserID'] = this.userID;
    data['RoleID'] = this.roleID;
    data['SSOID'] = this.ssoID;
    data['DistrictCode'] = this.districtCode;
    data['DisplayName'] = this.displayName;
    data['Mobileno'] = this.mobileno;
    data['MailPersonal'] = this.mailPersonal;
    data['MailOfficial'] = this.mailOfficial;
    data['Designation'] = this.designation;
    data['DepartmentName'] = this.departmentName;
    data['EmployeeNumber'] = this.empNumber;
    data['DepartmentID'] = this.deptID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['JanaadhaarId'] = this.janaadhaarId;
    data['UserType'] = this.userType;
    data['Eng_NonEng'] = this.eng_NonEng;
    data['Eng_NonEngName'] = this.eng_NonEngName;
    data['FinancialYearID'] = this.finYearID;
    data['UserRequestStatus'] = this.userReqStatus;
    data['LoginStatus'] = this.loginStatus;
    data['OfficeID'] = this.officeID;
    data['Encrypted_SSOID'] = this.encrypted_SSOID;
    data['SearchRecordID'] = this.searchRecordID;
    data['SSOTOKEN'] = this.SSOTOKEN;
    data['InternshipDeptID'] = this.internDeptID;
    data['InternshipDeptTypeID'] = this.internDeptTypeID;
    data['NameAsjanAdhar'] = this.nameAsJanAdhar;
    data['DistrictEn'] = this.districtEn;
    data['Gender'] = this.gender;
    data['postalAddress'] = this.postalAddress;
    data['aadhaarId'] = this.aadhaarId;

    return data;
  }
}
