class DeptProfileModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptProfileModalData>? data;

  DeptProfileModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DeptProfileModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DeptProfileModalData>[];
      json['Data'].forEach((v) {
        data!.add(new DeptProfileModalData.fromJson(v));
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

class DeptProfileModalData {
  dynamic userID;
  dynamic userRoleRightID;
  dynamic SSOID;
  dynamic name;
  dynamic mobileNo;
  dynamic districtName;
  dynamic departmentName;
  dynamic allotedDepartmentName;
  dynamic officerName;
  dynamic nameAsPerAadhar;
  dynamic designationName;
  dynamic administrationDepartmentName;
  dynamic districtCode;
  dynamic departmentID;
  dynamic allotmentDeptId;
  dynamic gender;
  dynamic mailPersonal;
  dynamic mailOfficial;
  dynamic userType;
  dynamic lastName;
  dynamic empNumber;

  DeptProfileModalData(
      {this.userID,
        this.userRoleRightID,
        this.SSOID,
        this.name,
        this.mobileNo,
        this.districtName,
        this.departmentName,
        this.allotedDepartmentName,
        this.officerName,
        this.nameAsPerAadhar,
        this.designationName,
        this.administrationDepartmentName,
        this.districtCode,
        this.departmentID,
        this.allotmentDeptId,
        this.gender,
        this.mailPersonal,
        this.mailOfficial,
        this.userType,
        this.lastName,
        this.empNumber,
      });

  DeptProfileModalData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    userRoleRightID = json['UserRoleRightID'];
    SSOID = json['SSOID'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    districtName = json['DistrictName'];
    departmentName = json['DepartmentName'];
    allotedDepartmentName = json['AllotedDepartmentName'];
    officerName = json['OfficerName'];
    nameAsPerAadhar = json['NameAsPerAadhar'];
    designationName = json['DesignationName'];
    administrationDepartmentName = json['AdministrationDepartmentName'];
    districtCode = json['DistrictCode'];
    departmentID = json['DepartmentID'];
    allotmentDeptId = json['AllotmentDeptId'];
    gender = json['Gender'];
    mailPersonal = json['MailPersonal'];
    mailOfficial = json['MailOfficial'];
    userType = json['UserType'];
    lastName = json['LastName'];
    empNumber = json['EmployeeNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['UserRoleRightID'] = this.userRoleRightID;
    data['SSOID'] = this.SSOID;
    data['Name'] = this.name;
    data['MobileNo'] = this.mobileNo;
    data['DistrictName'] = this.districtName;
    data['DepartmentName'] = this.departmentName;
    data['AllotedDepartmentName'] = this.allotedDepartmentName;
    data['OfficerName'] = this.officerName;
    data['NameAsPerAadhar'] = this.nameAsPerAadhar;
    data['DesignationName'] = this.designationName;
    data['AdministrationDepartmentName'] = this.administrationDepartmentName;
    data['DistrictCode'] = this.districtCode;
    data['DepartmentID'] = this.departmentID;
    data['AllotmentDeptId'] = this.allotmentDeptId;
    data['Gender'] = this.gender;
    data['MailPersonal'] = this.mailPersonal;
    data['MailOfficial'] = this.mailOfficial;
    data['UserType'] = this.userType;
    data['LastName'] = this.lastName;
    data['EmployeeNumber'] = this.empNumber;
    return data;
  }
}
