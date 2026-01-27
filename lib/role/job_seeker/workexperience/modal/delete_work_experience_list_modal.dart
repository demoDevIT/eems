class WorkExperienceListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<WorkExperienceListData>? data;

  WorkExperienceListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  WorkExperienceListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <WorkExperienceListData>[];
      json['Data'].forEach((v) {
        data!.add(new WorkExperienceListData.fromJson(v));
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

class WorkExperienceListData {
  dynamic employmentID;
  dynamic jobTitle;
  dynamic empolyer;
  dynamic jobStartDate;
  dynamic jobEndDate;
  dynamic currentSalary;
  dynamic jobType;
  dynamic jobTypeId;
  dynamic natureofEmploymentId;
  dynamic natureofEmployment;
  dynamic jobResponsibilities;
  dynamic isCurrentWorking;
  dynamic nCOCode;
  dynamic nCO;
  dynamic isExperinced;
  dynamic employmentName;
  dynamic employmentInPast;
  dynamic address;
  dynamic stateId;
  dynamic districtId;
  dynamic locationId;

  WorkExperienceListData(
      {this.employmentID,
        this.jobTitle,
        this.empolyer,
        this.jobStartDate,
        this.jobEndDate,
        this.currentSalary,
        this.jobType,
        this.jobTypeId,
        this.natureofEmploymentId,
        this.natureofEmployment,
        this.jobResponsibilities,
        this.isCurrentWorking,
        this.nCOCode,
        this.nCO,
        this.isExperinced,
        this.employmentName,
        this.employmentInPast,
        this.address,
        this.stateId,
        this.districtId,
        this.locationId,
      });

  WorkExperienceListData.fromJson(Map<String, dynamic> json) {
    employmentID = json['EmploymentID'];
    jobTitle = json['JobTitle'];
    empolyer = json['Empolyer'];
    jobStartDate = json['JobStartDate'];
    jobEndDate = json['JobEndDate'];
    currentSalary = json['CurrentSalary'];
    jobType = json['JobType'];
    jobTypeId = json['JobTypeId'];
    natureofEmploymentId = json['NatureofEmploymentId'];
    natureofEmployment = json['NatureofEmployment'];
    jobResponsibilities = json['JobResponsibilities'];
    isCurrentWorking = json['IsCurrentWorking'];
    nCOCode = json['NCOCode'];
    nCO = json['NCO'];
    isExperinced = json['IsExperinced'];
    employmentName = json['EmploymentName'];
    employmentInPast = json['EmploymentInPast'];
    address = json['Address'];
    stateId = json['ID'];
    districtId = json['DISTRICT_CODE'];
    locationId = json['CityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmploymentID'] = this.employmentID;
    data['JobTitle'] = this.jobTitle;
    data['Empolyer'] = this.empolyer;
    data['JobStartDate'] = this.jobStartDate;
    data['JobEndDate'] = this.jobEndDate;
    data['CurrentSalary'] = this.currentSalary;
    data['JobType'] = this.jobType;
    data['JobTypeId'] = this.jobTypeId;
    data['NatureofEmploymentId'] = this.natureofEmploymentId;
    data['NatureofEmployment'] = this.natureofEmployment;
    data['JobResponsibilities'] = this.jobResponsibilities;
    data['IsCurrentWorking'] = this.isCurrentWorking;
    data['NCOCode'] = this.nCOCode;
    data['NCO'] = this.nCO;
    data['IsExperinced'] = this.isExperinced;
    data['EmploymentName'] = this.employmentName;
    data['EmploymentInPast'] = this.employmentInPast;
    data['Address'] = this.address;
    data['ID'] = this.stateId;
    data['DISTRICT_CODE'] = this.districtId;
    data['CityId'] = this.locationId;
    return data;
  }
}
