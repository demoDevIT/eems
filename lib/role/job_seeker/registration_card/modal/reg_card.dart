class RegCardInfoListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<RegCardInfoData>? data;

  RegCardInfoListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  RegCardInfoListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <RegCardInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new RegCardInfoData.fromJson(v));
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

class RegCardInfoData {
  dynamic userID;
  dynamic salutation;
  dynamic janAadhaarNo;
  dynamic janMemberId;
  dynamic aadharNo;
  dynamic firstName;
  dynamic lastName;
  dynamic fatherName;
  dynamic middleName;
  dynamic userImageUrl;
  dynamic fatherName1;
  dynamic dOB;
  dynamic minority;
  dynamic gender;
  dynamic mobileNumber;
  dynamic emailID;
  dynamic maritalStatus;
  dynamic casteCategory;
  dynamic religion;
  dynamic uidType;
  dynamic uidNumber;
  dynamic uidNCOCode;
  dynamic regNo;
  dynamic NCOCode;
  dynamic isDisablity;
  dynamic perAddress;
  dynamic pincode;
  dynamic highQuali;
  dynamic emailID1;
  dynamic registrationDate;
  dynamic exchangeName;

  RegCardInfoData(
      {this.userID,
        this.salutation,
        this.janAadhaarNo,
        this.janMemberId,
        this.aadharNo,
        this.firstName,
        this.lastName,
        this.fatherName,
        this.middleName,
        this.userImageUrl,
        this.fatherName1,
        this.dOB,
        this.minority,
        this.gender,
        this.mobileNumber,
        this.emailID,
        this.maritalStatus,
        this.casteCategory,
        this.religion,
        this.uidType,
        this.uidNumber,
        this.uidNCOCode,
        this.regNo,
        this.NCOCode,
        this.isDisablity,
        this.perAddress,
        this.pincode,
        this.highQuali,
        this.emailID1,
        this.registrationDate,
        this.exchangeName});

  RegCardInfoData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    salutation = json['Salutation'];
    janAadhaarNo = json['JanAadhaarNo'];
    janMemberId = json['JanMemberId'];
    aadharNo = json['AadharNo'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    fatherName = json['FatherName'];
    middleName = json['MiddleName'];
    userImageUrl = json['UserImageUrl'];
    fatherName1 = json['FatherName1'];
    dOB = json['DOB'];
    minority = json['Minority'];
    gender = json['GENDER'];
    mobileNumber = json['MobileNumber'];
    emailID = json['EmailID'];
    maritalStatus = json['MaritalStatus'];
    casteCategory = json['CasteCategory'];
    religion = json['Religion'];
    uidType = json['UIDType'];
    uidNumber = json['UIDNumber'];
    uidNCOCode = json['UIDNCOCode'];
    regNo = json['regNo'];
    NCOCode = json['NCOCode'];
    isDisablity = json['IsDisablity'];
    perAddress = json['PermanentAddress'];
    pincode = json['Pincode'];
    highQuali = json['highestQualification'];
    emailID1 = json['EMAIL_ID'];
    registrationDate = json['registrationDate'];
    exchangeName = json['exchangeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['Salutation'] = this.salutation;
    data['JanAadhaarNo'] = this.janAadhaarNo;
    data['JanMemberId'] = this.janMemberId;
    data['AadharNo'] = this.aadharNo;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['FatherName'] = this.fatherName;
    data['MiddleName'] = this.middleName;
    data['UserImageUrl'] = this.userImageUrl;
    data['FatherName1'] = this.fatherName1;
    data['DOB'] = this.dOB;
    data['Minority'] = this.minority;
    data['GENDER'] = this.gender;
    data['MobileNumber'] = this.mobileNumber;
    data['EmailID'] = this.emailID;
    data['MaritalStatus'] = this.maritalStatus;
    data['CasteCategory'] = this.casteCategory;
    data['Religion'] = this.religion;
    data['UIDType'] = this.uidType;
    data['UIDNumber'] = this.uidNumber;
    data['UIDNCOCode'] = this.uidNCOCode;
    data['regNo'] = this.regNo;
    data['NCOCode'] = this.NCOCode;
    data['IsDisablity'] = this.isDisablity;
    data['PermanentAddress'] = this.perAddress;
    data['Pincode'] = this.pincode;
    data['highestQualification'] = this.highQuali;
    data['EMAIL_ID'] = this.emailID1;
    data['registrationDate'] = this.registrationDate;
    data['exchangeName'] = this.exchangeName;
    return data;
  }
}
