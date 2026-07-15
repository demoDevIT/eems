class ApprovalData {
  int? userID;
  int? officeID;
  int? departmentID;
  int? allotmentDeptId;

  String? ssoID;
  String? name;
  String? mobileNo;
  String? districtName;
  String? districtCode;
  String? departmentName;
  String? allotedDepartmentName;
  String? officerName;
  String? nameAsPerAadhar;
  String? designationName;
  String? administrationDepartmentName;
  String? msg;

  ApprovalData.fromJson(Map<String, dynamic> json) {
    userID = json["UserID"];
    officeID = json["OfficeID"];
    departmentID = json["DepartmentID"];
    allotmentDeptId = json["AllotmentDeptId"];

    ssoID = json["SSOID"];
    name = json["Name"];
    mobileNo = json["MobileNo"];
    districtName = json["DistrictName"];
    districtCode = json["DistrictCode"];
    departmentName = json["DepartmentName"];
    allotedDepartmentName = json["AllotedDepartmentName"];
    officerName = json["OfficerName"];
    nameAsPerAadhar = json["NameAsPerAadhar"];
    designationName = json["DesignationName"];
    administrationDepartmentName =
    json["AdministrationDepartmentName"];
    msg = json["MSG"];
  }
}