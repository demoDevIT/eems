class LoginModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  LoginData? data;

  LoginModal(
      {
        this.state,
        this.status,
        this.message,
        this.errorMessage,
        this.data
      });

  LoginModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new LoginData.fromJson(json['Data']) : null;
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

class LoginData {
  int? userId;
  int? roleId;
  dynamic isLogin;
  String? username;
  String? password;

  //jobseeker
  int? jobSeekerID;
  String? registrationNumber;
  String? registrationDate;
  String? nAMEENG;
  String? nAMEHINDI;
  String? fATHERNAMEENG;
  String? fATHERNAMEHND;
  String? dOB;
  String? gENDER;
  String? mOBILENO;
  String? eMAILID;
  String? caste;
  String? religion;
  String? latestPhoto;
  String? nCOCode;
  String? aadharNo;
  int? miniority;
  dynamic uIDName;
  int? uIDType;
  String? uIDNumber;
  String? latestPhotoPath;
  String? maritalStatus;
  String? familyIncome;

  //employer
  String? brn;
  String? district;
  String? area;
  String? tehsil;
  String? localBody;
  String? ward;
  String? branchName;
  String? branchHouseNumber;
  String? branchLane;
  String? branchLocality;
  String? branchPincode;
  String? boTelNo;
  String? branchEmail;
  String? docGSTNumber;
  String? branchPANVerified;
  String? branchPANHolder;
  String? branchTANNumber;
  String? headName;
  String? hoTelno;
  String? hoCompanyEmail;
  String? hoPanNumber;
  String? headHouseNumber;
  String? headLane;
  String? headLocality;
  String? hoPinCode;
  String? applicantName;
  String? applicantNo;
  String? applicantEmail;
  String? year;
  String? ownership;
  String? totalPerson;
  String? actRegNo;
  String? hoTanNo;
  String? hoApplicationEmail;
  String? hoStateId;
  String? hoDistrictId;
  String? hoCityId;
  String? webSite;
  String? applicantAddress;
  String? contactPANNo;
  String? contactFirstName;
  String? contactLastName;
  String? contactMobileNumber;
  String? contactAlternateMobileNumber;
  String? contactEmail;
  String? contactState;
  String? contactDistrict;
  String? contactCity;
  String? contactPincode;
  String? contactAddress;
  String? contactDesignation;
  String? contactdepartment;

  LoginData({
    this.userId,
    this.roleId,
    this.isLogin,
    this.username,
    this.password,

    //jobseeker
    this.jobSeekerID,
    this.registrationNumber,
    this.registrationDate,
    this.nAMEENG,
    this.nAMEHINDI,
    this.fATHERNAMEENG,
    this.fATHERNAMEHND,
    this.dOB,
    this.gENDER,
    this.mOBILENO,
    this.eMAILID,
    this.caste,
    this.religion,
    this.latestPhoto,
    this.nCOCode,
    this.aadharNo,
    this.miniority,
    this.uIDName,
    this.uIDType,
    this.uIDNumber,
    this.latestPhotoPath,
    this.maritalStatus,
    this.familyIncome,

    //employer
    this.brn,
    this.district,
    this.area,
    this.tehsil,
    this.localBody,
    this.ward,
    this.branchName,
    this.branchHouseNumber,
    this.branchLane,
    this.branchLocality,
    this.branchPincode,
    this.boTelNo,
    this.branchEmail,
    this.docGSTNumber,
    this.branchPANVerified,
    this.branchPANHolder,
    this.branchTANNumber,
    this.headName,
    this.hoTelno,
    this.hoCompanyEmail,
    this.hoPanNumber,
    this.headHouseNumber,
    this.headLane,
    this.headLocality,
    this.hoPinCode,
    this.applicantName,
    this.applicantNo,
    this.applicantEmail,
    this.year,
    this.ownership,
    this.totalPerson,
    this.actRegNo,
    this.hoTanNo,
    this.hoApplicationEmail,
    this.hoStateId,
    this.hoDistrictId,
    this.hoCityId,
    this.webSite,
    this.applicantAddress,
    this.contactPANNo,
    this.contactFirstName,
    this.contactLastName,
    this.contactMobileNumber,
    this.contactAlternateMobileNumber,
    this.contactEmail,
    this.contactState,
    this.contactDistrict,
    this.contactCity,
    this.contactPincode,
    this.contactAddress,
    this.contactDesignation,
    this.contactdepartment
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    isLogin = json['isLogin'];
    username = json['username'];
    password = json['password'];

    //jobseeker
    jobSeekerID = json['JobSeekerID'];
    registrationNumber = json['RegistrationNumber'];
    registrationDate = json['RegistrationDate'];
    nAMEENG = json['NAME_ENG'];
    nAMEHINDI = json['NAME_HINDI'];
    fATHERNAMEENG = json['FATHER_NAME_ENG'];
    fATHERNAMEHND = json['FATHER_NAME_HND'];
    dOB = json['DOB'];
    gENDER = json['GENDER'];
    mOBILENO = json['MOBILE_NO'];
    eMAILID = json['EMAIL_ID'];
    caste = json['Caste'];
    religion = json['Religion'];
    latestPhoto = json['LatestPhoto'];
    nCOCode = json['NCO_Code'];
    aadharNo = json['AadharNo'];
    miniority = json['Miniority'];
    uIDName = json['UIDName'];
    uIDType = json['UIDType'];
    uIDNumber = json['UIDNumber'];
    latestPhotoPath = json['LatestPhotoPath'];
    maritalStatus = json['MaritalStatus'];
    familyIncome = json['FamilyIncome'];

    //employer
    brn = json['BRN'];
    district = json['District'];
    area = json['Area'];
    tehsil = json['Tehsil'];
    localBody = json['LocalBody'];
    ward = json['Ward'];
    branchName = json['Branch_Name'];
    branchHouseNumber = json['Branch_HouseNumber'];
    branchLane = json['Branch_Lane'];
    branchLocality = json['Branch_Locality'];
    branchPincode = json['Branch_Pincode'];
    boTelNo = json['BO_TelNo'];
    branchEmail = json['Branch_Email'];
    docGSTNumber = json['DocGSTNumber'];
    branchPANVerified = json['Branch_PANVerified'];
    branchPANHolder = json['Branch_PANHolder'];
    branchTANNumber = json['Branch_TANNumber'];
    headName = json['Head_Name'];
    hoTelno = json['HO_telno'];
    hoCompanyEmail = json['HOCompanyEmail'];
    hoPanNumber = json['HOPannumber'];
    headHouseNumber = json['Head_HouseNumber'];
    headLane = json['Head_Lane'];
    headLocality = json['Head_Locality'];
    hoPinCode = json['HOPinCode'];
    applicantName = json['Applicant_Name'];
    applicantNo = json['Applicant_No'];
    applicantEmail = json['Applicant_Email'];
    year = json['Year'];
    ownership = json['Ownership'];
    totalPerson = json['Total_Person'];
    actRegNo = json['ACTRegNo'];
    hoTanNo = json['HO_TanNo'];
    hoApplicationEmail = json['HO_applicatoinEmail'];
    hoStateId = json['HOStateId'];
    hoDistrictId = json['HODistrictId'];
    hoCityId = json['HOCityId'];
    webSite = json['WebSite'];
    applicantAddress = json['Applicant_Address'];
    contactPANNo = json['Contact_PAN_No'];
    contactFirstName = json['Contact_FirstName'];
    contactLastName = json['Contact_LastName'];
    contactMobileNumber = json['Contact_MobileNumber'];
    contactAlternateMobileNumber = json['Contact_AlternateMobileNumber'];
    contactEmail = json['Contact_Email'];
    contactState = json['Contact_State'];
    contactDistrict = json['Contact_District'];
    contactCity = json['Contact_City'];
    contactPincode = json['Contact_Pincode'];
    contactAddress = json['Contact_Address'];
    contactDesignation = json['Contact_Designation'];
    contactdepartment = json['Contact_Department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['RoleId'] = this.roleId;
    data['isLogin'] = this.isLogin;
    data['username'] = this.username;
    data['password'] = this.password;

    //jobseeker
    data['JobSeekerID'] = this.jobSeekerID;
    data['RegistrationNumber'] = this.registrationNumber;
    data['RegistrationDate'] = this.registrationDate;
    data['NAME_ENG'] = this.nAMEENG;
    data['NAME_HINDI'] = this.nAMEHINDI;
    data['FATHER_NAME_ENG'] = this.fATHERNAMEENG;
    data['FATHER_NAME_HND'] = this.fATHERNAMEHND;
    data['DOB'] = this.dOB;
    data['GENDER'] = this.gENDER;
    data['MOBILE_NO'] = this.mOBILENO;
    data['EMAIL_ID'] = this.eMAILID;
    data['Caste'] = this.caste;
    data['Religion'] = this.religion;
    data['LatestPhoto'] = this.latestPhoto;
    data['NCO_Code'] = this.nCOCode;
    data['AadharNo'] = this.aadharNo;
    data['Miniority'] = this.miniority;
    data['UIDName'] = this.uIDName;
    data['UIDType'] = this.uIDType;
    data['UIDNumber'] = this.uIDNumber;
    data['LatestPhotoPath'] = this.latestPhotoPath;
    data['MaritalStatus'] = this.maritalStatus;
    data['FamilyIncome'] = this.familyIncome;

    //employer
    data['BRN'] = this.brn;
    data['District'] = this.district;
    data['Area'] = this.area;
    data['Tehsil'] = this.tehsil;
    data['LocalBody'] = this.localBody;
    data['Ward'] = this.ward;
    data['Branch_Name'] = this.branchName;
    data['Branch_HouseNumber'] = this.branchHouseNumber;
    data['Branch_Lane'] = this.branchLane;
    data['Branch_Locality'] = this.branchLocality;
    data['Branch_Pincode'] = this.branchPincode;
    data['BO_TelNo'] = this.boTelNo;
    data['Branch_Email'] = this.branchEmail;
    data['DocGSTNumber'] = this.docGSTNumber;
    data['Branch_PANVerified'] = this.branchPANVerified;
    data['Branch_PANHolder'] = this.branchPANHolder;
    data['Branch_TANNumber'] = this.branchTANNumber;
    data['Head_Name'] = this.headName;
    data['HO_telno'] = this.hoTelno;
    data['HOCompanyEmail'] = this.hoCompanyEmail;
    data['HOPannumber'] = this.hoPanNumber;
    data['Head_HouseNumber'] = this.headHouseNumber;
    data['Head_Lane'] = this.headLane;
    data['Head_Locality'] = this.headLocality;
    data['HOPinCode'] = this.hoPinCode;
    data['Applicant_Name'] = this.applicantName;
    data['Applicant_No'] = this.applicantNo;
    data['Applicant_Email'] = this.applicantEmail;
    data['Year'] = this.year;
    data['Ownership'] = this.ownership;
    data['Total_Person'] = this.totalPerson;
    data['ACTRegNo'] = this.actRegNo;
    data['HO_TanNo'] = this.hoTanNo;
    data['HO_applicatoinEmail'] = this.hoApplicationEmail;
    data['HOStateId'] = this.hoStateId;
    data['HODistrictId'] = this.hoDistrictId;
    data['HOCityId'] = this.hoCityId;
    data['WebSite'] = this.webSite;
    data['Applicant_Address'] = this.applicantAddress;
    data['Contact_PAN_No'] = this.contactPANNo;
    data['Contact_FirstName'] = this.contactFirstName;
    data['Contact_LastName'] = this.contactLastName;
    data['Contact_MobileNumber'] = this.contactMobileNumber;
    data['Contact_AlternateMobileNumber'] = this.contactAlternateMobileNumber;
    data['Contact_Email'] = this.contactEmail;
    data['Contact_State'] = this.contactState;
    data['Contact_District'] = this.contactDistrict;
    data['Contact_City'] = this.contactCity;
    data['Contact_Pincode'] = this.contactPincode;
    data['Contact_Address'] = this.contactAddress;
    data['Contact_Designation'] = this.contactDesignation;
    data['Contact_Department'] = this.contactdepartment;

    return data;
  }
}
 
