class EmpInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<EmpInfoData>? data;

  EmpInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  EmpInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <EmpInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new EmpInfoData.fromJson(v));
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

class EmpInfoData {
  dynamic userID;
  dynamic brn;
  dynamic district;
  dynamic area;
  dynamic tehsil;
  dynamic localBody;
  dynamic ward;
  dynamic branchName;
  dynamic branchHouseNumber;
  dynamic branchLane;
  dynamic branchLocality;
  dynamic branchPincode;
  dynamic boTelNo;
  dynamic branchEmail;
  dynamic docGSTNumber;
  dynamic branchPANVerified;
  dynamic branchPANHolder;
  dynamic branchTANNumber;
  dynamic headName;
  dynamic hoTelno;
  dynamic hoCompanyEmail;
  dynamic hoPanNumber;
  dynamic headHouseNumber;
  dynamic headLane;
  dynamic headLocality;
  dynamic hoPinCode;
  dynamic applicantName;
  dynamic applicantNo;
  dynamic applicantEmail;
  dynamic year;
  dynamic ownership;
  dynamic totalPerson;
  dynamic actRegNo;
  dynamic hoTanNo;
  dynamic hoApplicationEmail;
  dynamic hoStateId;
  dynamic hoDistrictId;
  dynamic hoCityId;
  dynamic webSite;
  dynamic applicantAddress;
  dynamic nicCode;
  dynamic contactPANNo;
  dynamic contactFirstName;
  dynamic contactLastName;
  dynamic contactMobileNumber;
  dynamic contactAlternateMobileNumber;
  dynamic contactEmail;
  dynamic contactState;
  dynamic contactDistrict;
  dynamic contactCity;
  dynamic contactPincode;
  dynamic contactAddress;
  dynamic contactDesignation;
  dynamic contactdepartment;



  EmpInfoData(
      {this.userID,
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
        this.nicCode,
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

  EmpInfoData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
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
    year = json['Year'].toString();
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
    nicCode = json['NIC_Code'];
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
    data['UserID'] = this.userID;
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
    data['NIC_Code'] = this.nicCode;
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
