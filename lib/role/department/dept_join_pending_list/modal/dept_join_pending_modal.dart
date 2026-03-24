class DeptJoinPendingModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptJoinPendingItem>? data;

  DeptJoinPendingModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DeptJoinPendingModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DeptJoinPendingItem>[];
      json['Data'].forEach((v) {
        data!.add(DeptJoinPendingItem.fromJson(v));
      });
    }
  }
}

class DeptJoinPendingItem {
  // String? jobseekerUserId;
  // String? applicationNo;
  // String? name;
  // String? fatherName;
  // String? schemeName;
  // String? aadharNo;
  // String? gender;
  // String? category;
  // String? schemeStatus;
  // String? allotmentDate;
  // String? technicalCourse;

    int? RSLDCTrainingAllotID;
    String? internJoiningDate;
    String? applicationApprovalDate;
    int? jobSeekerUserId;
    int? jobSeekerID;
    int? privateDepartmentID;
    String? allottedDeptName;
    String? mobileNo;
    String? nameEng;
    String? fNameEng;
    String? gender;
    String? dob;
    String? applyDate;
    String? regNo;
    String? photo;
    String? districtName;
    String? lastActionDate;
    String? deptAllotmentDate;
    String? departmentNameEn;
    String? allotmentDeptName;

    // String? areaType;
    // String? privateDistrictCode;
    // String? privateCityCode;
    // String? privateBlockCode;
    // String? privateGPCode;
    // String? privateWardCode;
    // String? privateVillageCode;
    // String? ssoid;
    // String? designation;
    // String? cityName;
    // String? wardName;
    // String? blockName;
    // String? gpName;
    // String? villageName;
    // String? internshipPdfPath;


  DeptJoinPendingItem({
    this.RSLDCTrainingAllotID,
    this.internJoiningDate,
    this.applicationApprovalDate,
    this.jobSeekerUserId,
    this.jobSeekerID,
    this.privateDepartmentID,
    this.allottedDeptName,
    this.mobileNo,
    this.nameEng,
    this.fNameEng,
    this.gender,
    this.dob,
    this.applyDate,
    this.regNo,
    this.photo,
    this.districtName,
    this.lastActionDate,
    this.deptAllotmentDate,
    this.departmentNameEn,
    this.allotmentDeptName

    // this.areaType,
    // this.privateDistrictCode,
    // this.privateCityCode,
    // this.privateBlockCode,
    // this.privateGPCode,
    // this.privateWardCode,
    // this.privateVillageCode,
    // this.ssoid,
    // this.designation,
    // this.cityName,
    // this.wardName,
    // this.blockName,
    // this.gpName,
    // this.villageName,
    // this.departmentNameEn,
    // this.internshipPdfPath,
  });

  factory DeptJoinPendingItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinPendingItem(
      RSLDCTrainingAllotID: json['RSLDCTrainingAllotID'],
      internJoiningDate: json['InternJoiningDate'],
      applicationApprovalDate: json['ApplicationApprovalDate_DDMMYYYY'],
      jobSeekerUserId: json['JobSeekerUserId'],
      jobSeekerID: json['JobSeekerID'],
      privateDepartmentID: json['PrivateDepartmentID'],
      allottedDeptName: json['AllottedDeptName'],
      mobileNo: json['MOBILE_NO'],
      nameEng: json['NAME_ENG'],
      fNameEng: json['FATHER_NAME_ENG'],
      gender: json['GENDER'],
      dob: json['DOB_DDMMYYYY'],
      applyDate: json['ApplyDate_DDMMYYYY'],
      regNo: json['RegistrationNumber'],
      photo: json['LatestPhoto'],
      districtName: json['DistrictName'],
      lastActionDate: json['LastActionDate'],
      deptAllotmentDate: json['DeptAllotmentDate_DDMMYYYY'],
      departmentNameEn: json['DepartmentNameEn'],
      allotmentDeptName: json['AllotmentDeptName'],

      // areaType: json['AreaType'],
      // privateDistrictCode: json['PrivateDistrictCode'],
      // privateCityCode: json['PrivateCityCode'],
      // privateBlockCode: json['PrivateBlockCode'],
      // privateGPCode: json['PrivateGPCode'],
      // privateWardCode: json['PrivateWardCode'],
      // privateVillageCode: json['PrivateVillageCode'],
      // ssoid: json['SSOID'],
      // mobileNo: json['MobileNo'],
      // designation: json['Designation'],
      // cityName: json['CityName'],
      // wardName: json['WardName'],
      // blockName: json['BlockName'],
      // gpName: json['GPName'],
      // villageName: json['VillageName'],
      // internshipPdfPath: json['InternshipPdfPath'],
    );
  }
}
