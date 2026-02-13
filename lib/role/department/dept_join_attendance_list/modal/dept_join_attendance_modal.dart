class DeptJoinAttendanceModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptJoinAttendanceItem>? data;

  DeptJoinAttendanceModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DeptJoinAttendanceModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DeptJoinAttendanceItem>[];
      json['Data'].forEach((v) {
        data!.add(DeptJoinAttendanceItem.fromJson(v));
      });
    }
  }
}

class DeptJoinAttendanceItem {
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

    String? areaType;
    String? privateDistrictCode;
    String? privateCityCode;
    String? privateBlockCode;
    String? privateGPCode;
    String? privateWardCode;
    String? privateVillageCode;
    int? privateDepartmentID;
    String? ssoid;
    String? officerName;
    String? mobileNo;
    String? designation;
    String? nameEng;
    String? districtName;
    String? cityName;
    String? wardName;
    String? blockName;
    String? gpName;
    String? villageName;
    String? departmentNameEn;

  DeptJoinAttendanceItem({
    // this.jobseekerUserId,
    // this.applicationNo,
    // this.name,
    // this.fatherName,
    // this.schemeName,
    // this.aadharNo,
    // this.gender,
    // this.category,
    // this.schemeStatus,
    // this.allotmentDate,
    // this.technicalCourse,

      this.areaType,
      this.privateDistrictCode,
      this.privateCityCode,
      this.privateBlockCode,
      this.privateGPCode,
      this.privateWardCode,
      this.privateVillageCode,
      this.privateDepartmentID,
      this.ssoid,
      this.officerName,
      this.mobileNo,
      this.designation,
      this.nameEng,
      this.districtName,
      this.cityName,
      this.wardName,
      this.blockName,
      this.gpName,
      this.villageName,
      this.departmentNameEn,
  });

  factory DeptJoinAttendanceItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinAttendanceItem(
      // jobseekerUserId: json['JobseekerUserID']?.toString(),
      // applicationNo: json['ApplicationNo'],
      // name: json['JobseekerName'],
      // fatherName: json['FatherName'],
      // schemeName: json['SchemeName'],
      // aadharNo: json['AadharNo'],
      // gender: json['Gender'],
      // category: json['Category'],
      // schemeStatus: json['SchemeStatus'],
      // allotmentDate: json['CreatedOn'],
      // technicalCourse: json['TechnicalCourse'], // shown as Exchange Name

      areaType: json['AreaType']?.toString(),
      privateDistrictCode: json['PrivateDistrictCode'],
      privateCityCode: json['PrivateCityCode'],
      privateBlockCode: json['PrivateBlockCode'],
      privateGPCode: json['PrivateGPCode'],
      privateWardCode: json['PrivateWardCode'],
      privateVillageCode: json['PrivateVillageCode'],
      privateDepartmentID: json['PrivateDepartmentID'],
      ssoid: json['SSOID'],
      officerName: json['OfficerName'],
      mobileNo: json['MobileNo'],
      designation: json['Designation'],
      nameEng: json['NAME_ENG'],
      districtName: json['DistrictName'],
      cityName: json['CityName'],
      wardName: json['WardName'],
      blockName: json['BlockName'],
      gpName: json['GPName'],
      villageName: json['VillageName'],
      departmentNameEn: json['DepartmentNameEn'],

    );
  }
}
