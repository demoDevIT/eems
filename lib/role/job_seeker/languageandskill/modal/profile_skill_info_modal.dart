class ProfileSkillInfoModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ProfileSkillInfoData>? data;

  ProfileSkillInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ProfileSkillInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ProfileSkillInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new ProfileSkillInfoData.fromJson(v));
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

class ProfileSkillInfoData {
  dynamic skillDetailID;
  dynamic categoryName;
  dynamic subCategoryName;
  dynamic acquiredName;
  dynamic experienceInYear;
  dynamic experienceInMonth;
  dynamic remarks;
  dynamic certificatePath;
  dynamic subCategoryID;
  dynamic categoryID;
  dynamic acquiredThroughID;
  dynamic remarks1;
  dynamic nCOCode;
  dynamic nCO;
  dynamic isActive;
  dynamic isSkilled;

  ProfileSkillInfoData(
      {this.skillDetailID,
        this.categoryName,
        this.subCategoryName,
        this.acquiredName,
        this.experienceInYear,
        this.experienceInMonth,
        this.remarks,
        this.certificatePath,
        this.subCategoryID,
        this.categoryID,
        this.acquiredThroughID,
        this.remarks1,
        this.nCOCode,
        this.nCO,
        this.isActive,
        this.isSkilled});

  ProfileSkillInfoData.fromJson(Map<String, dynamic> json) {
    skillDetailID = json['SkillDetailID'];
    categoryName = json['CategoryName'];
    subCategoryName = json['SubCategoryName'];
    acquiredName = json['AcquiredName'];
    experienceInYear = json['ExperienceInYear'];
    experienceInMonth = json['ExperienceInMonth'];
    remarks = json['Remarks'];
    certificatePath = json['CertificatePath'];
    subCategoryID = json['SubCategoryID'];
    categoryID = json['CategoryID'];
    acquiredThroughID = json['AcquiredThroughID'];
    remarks1 = json['Remarks1'];
    nCOCode = json['NCOCode'];
    nCO = json['NCO'];
    isActive = json['IsActive'];
    isSkilled = json['IsSkilled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SkillDetailID'] = this.skillDetailID;
    data['CategoryName'] = this.categoryName;
    data['SubCategoryName'] = this.subCategoryName;
    data['AcquiredName'] = this.acquiredName;
    data['ExperienceInYear'] = this.experienceInYear;
    data['ExperienceInMonth'] = this.experienceInMonth;
    data['Remarks'] = this.remarks;
    data['CertificatePath'] = this.certificatePath;
    data['SubCategoryID'] = this.subCategoryID;
    data['CategoryID'] = this.categoryID;
    data['AcquiredThroughID'] = this.acquiredThroughID;
    data['Remarks1'] = this.remarks1;
    data['NCOCode'] = this.nCOCode;
    data['NCO'] = this.nCO;
    data['IsActive'] = this.isActive;
    data['IsSkilled'] = this.isSkilled;
    return data;
  }
}
