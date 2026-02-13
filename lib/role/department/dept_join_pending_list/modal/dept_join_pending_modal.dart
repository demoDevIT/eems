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

    int? jobSeekerUserId;
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
    String? internshipPdfPath;

  DeptJoinPendingItem({
    this.jobSeekerUserId,
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
    this.internshipPdfPath,
  });

  factory DeptJoinPendingItem.fromJson(Map<String, dynamic> json) {
    return DeptJoinPendingItem(
      jobSeekerUserId: json['JobSeekerUserId'],
      areaType: json['AreaType'],
      privateDistrictCode: json['PrivateDistrictCode'],
      privateCityCode: json['PrivateCityCode'],
      privateBlockCode: json['PrivateBlockCode'],
      privateGPCode: json['PrivateGPCode'],
      privateWardCode: json['PrivateWardCode'],
      privateVillageCode: json['PrivateVillageCode'],
      privateDepartmentID: json['PrivateDepartmentID'],
      ssoid: json['SSOID'],
      officerName: json['OfficerName'], // shown as Exchange Name
      mobileNo: json['MobileNo'], // shown as Exchange Name
      designation: json['Designation'], // shown as Exchange Name
      nameEng: json['NAME_ENG'], // shown as Exchange Name
      districtName: json['DistrictName'], // shown as Exchange Name
      cityName: json['CityName'], // shown as Exchange Name
      wardName: json['WardName'], // shown as Exchange Name
      blockName: json['BlockName'], // shown as Exchange Name
      gpName: json['GPName'], // shown as Exchange Name
      villageName: json['VillageName'], // shown as Exchange Name
      departmentNameEn: json['DepartmentNameEn'], // shown as Exchange Name
      internshipPdfPath: json['InternshipPdfPath'], // shown as Exchange Name
    );
  }
}
