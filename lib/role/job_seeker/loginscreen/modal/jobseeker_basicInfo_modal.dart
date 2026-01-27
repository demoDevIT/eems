class JobseekerBasicInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<JobseekerBasicInfoData>? data;

  JobseekerBasicInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobseekerBasicInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobseekerBasicInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new JobseekerBasicInfoData.fromJson(v));
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

class JobseekerBasicInfoData {
  int? userID;
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

  JobseekerBasicInfoData(
      {this.userID,
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
        this.familyIncome,});

  JobseekerBasicInfoData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
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
    return data;
  }
}
