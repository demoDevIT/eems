class JobPreferenceModal {
  dynamic state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  List<JobPreferenceData>? data;

  JobPreferenceModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobPreferenceModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobPreferenceData>[];
      json['Data'].forEach((v) {
        data!.add(new JobPreferenceData.fromJson(v));
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

class JobPreferenceData {
  dynamic maximumm;
  dynamic jobPreferenceID;
  dynamic sectorId;
  dynamic preLocation;
  dynamic salarymin;
  dynamic salarymax;
  dynamic employmenttype;
  dynamic jobType;
  dynamic shift;
  dynamic nCOCode;
  dynamic isInternationalJob;
  dynamic preferredRegion;
  dynamic foreignLanguageKnown;
  dynamic foreignLanguageName;
  dynamic preLocationName;
  dynamic sectorName;
  dynamic employmenttypeName;
  dynamic jobTypeName;
  dynamic shiftName;
  dynamic preferredRegionName;
  dynamic nCO;

  JobPreferenceData(
      {this.maximumm,
        this.jobPreferenceID,
        this.sectorId,
        this.preLocation,
        this.salarymin,
        this.salarymax,
        this.employmenttype,
        this.jobType,
        this.shift,
        this.nCOCode,
        this.isInternationalJob,
        this.preferredRegion,
        this.foreignLanguageKnown,
        this.foreignLanguageName,
        this.preLocationName,
        this.sectorName,
        this.employmenttypeName,
        this.jobTypeName,
        this.shiftName,
        this.preferredRegionName,
        this.nCO});

  JobPreferenceData.fromJson(Map<String, dynamic> json) {
    maximumm = json['Maximum'];
    jobPreferenceID = json['JobPreferenceID'];
    sectorId = json['SectorId'];
    preLocation = json['PreLocation'];
    salarymin = json['Salarymin'];
    salarymax = json['Salarymax'];
    employmenttype = json['Employmenttype'];
    jobType = json['JobType'];
    shift = json['Shift'];
    nCOCode = json['NCOCode'];
    isInternationalJob = json['IsInternationalJob'];
    preferredRegion = json['PreferredRegion'];
    foreignLanguageKnown = json['ForeignLanguageKnown'];
    foreignLanguageName = json['ForeignLanguageName'];
    preLocationName = json['PreLocationName'];
    sectorName = json['SectorName'];
    employmenttypeName = json['EmploymenttypeName'];
    jobTypeName = json['JobTypeName'];
    shiftName = json['ShiftName'];
    preferredRegionName = json['PreferredRegionName'];
    nCO = json['NCO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Maximum'] = this.maximumm;
    data['JobPreferenceID'] = this.jobPreferenceID;
    data['SectorId'] = this.sectorId;
    data['PreLocation'] = this.preLocation;
    data['Salarymin'] = this.salarymin;
    data['Salarymax'] = this.salarymax;
    data['Employmenttype'] = this.employmenttype;
    data['JobType'] = this.jobType;
    data['Shift'] = this.shift;
    data['NCOCode'] = this.nCOCode;
    data['IsInternationalJob'] = this.isInternationalJob;
    data['PreferredRegion'] = this.preferredRegion;
    data['ForeignLanguageKnown'] = this.foreignLanguageKnown;
    data['ForeignLanguageName'] = this.foreignLanguageName;
    data['PreLocationName'] = this.preLocationName;
    data['SectorName'] = this.sectorName;
    data['EmploymenttypeName'] = this.employmenttypeName;
    data['JobTypeName'] = this.jobTypeName;
    data['ShiftName'] = this.shiftName;
    data['PreferredRegionName'] = this.preferredRegionName;
    data['NCO'] = this.nCO;
    return data;
  }
}
