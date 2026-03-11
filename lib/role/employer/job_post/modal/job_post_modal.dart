class JobPostModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<JobPostData>? data;

  JobPostModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobPostModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null && json['Data']['Table'] != null) {
      data = <JobPostData>[];
      json['Data']['Table'].forEach((v) {
        data!.add(JobPostData.fromJson(v));
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

class JobPostData {
  dynamic eventName;
  dynamic jobPostId;
  dynamic jobPosition;
  dynamic maleVacancy;
  dynamic femaleVacancy;
  dynamic otherVacancy;
  dynamic anyVacancy;
  dynamic desc;
  dynamic closeDate;
  dynamic ncoCode;
  dynamic sectorName;
  dynamic sectorID;
  dynamic minAgeLimit;
  dynamic maxAgeLimit;
  dynamic minSalary;
  dynamic maxSalary;
  dynamic eventID;
  dynamic skillSetId;
  dynamic postCreationDate;
  dynamic educationalDetailsId;
  dynamic startDates;
  dynamic jobTitleId;
  dynamic startDateStatus;
  dynamic today;
  dynamic qualification;
  dynamic skillName;
  dynamic graducationTypeID;
  dynamic skillSubCateId;
  dynamic skillSubcateName;
  dynamic fileName;
  dynamic preLocation;
  dynamic employmentType;
  dynamic natureOfJob;
  dynamic workExperience;
  dynamic NoOfExpYear;
  dynamic jobTitleId1;

  JobPostData(
      {this.eventName,
        this.jobPostId,
        this.jobPosition,
        this.maleVacancy,
        this.femaleVacancy,
        this.otherVacancy,
        this.anyVacancy,
        this.desc,
        this.closeDate,
        this.ncoCode,
        this.sectorName,
        this.sectorID,
        this.minAgeLimit,
        this.maxAgeLimit,
        this.minSalary,
        this.maxSalary,
        this.eventID,
        this.skillSetId,
        this.postCreationDate,
        this.educationalDetailsId,
        this.startDates,
        this.jobTitleId,
        this.startDateStatus,
        this.today,
        this.qualification,
        this.skillName,
        this.graducationTypeID,
        this.skillSubCateId,
        this.skillSubcateName,
        this.fileName,
        this.preLocation,
        this.employmentType,
        this.natureOfJob,
        this.workExperience,
        this.NoOfExpYear,
        this.jobTitleId1,
      });

  JobPostData.fromJson(Map<String, dynamic> json) {
    eventName = json['EventName_ENG'];
    jobPostId = json['JobPostId'];
    jobPosition = json['JobPositionTitle_ENG'];
    maleVacancy = json['Male_NoOfVacancy'];
    femaleVacancy = json['Female_NoOfVacancy'];
    otherVacancy = json['Other_NoOfVacancy'];
    anyVacancy = json['Any_NoOfVacancy'];
    desc = json['Description'];
    closeDate = json['Closing_Date'];
    ncoCode = json['NCO_Code'];
    sectorName = json['JobNameEn'];
    sectorID = json['JobSectorId'];
    minAgeLimit = json['Min_AgeLimit'];
    maxAgeLimit = json['Max_AgeLimit'];
    minSalary = json['MinSalary'];
    maxSalary = json['MaxSalary'];
    eventID = json['EventID'];
    skillSetId = json['SkillSetId'];
    postCreationDate = json['PostCreationDate'];
    educationalDetailsId = json['EducationalDetailsId'];
    startDates = json['Start_Dates'];
    jobTitleId = json['JobTitleId'];
    startDateStatus = json['StartDateStatus'];
    today = json['Today'];
    qualification = json['Qualification_ENG'];
    skillName = json['SkillNameEn'];
    graducationTypeID = json['GraducationTypeID'];
    skillSubCateId = json['SkillSubCateId'];
    skillSubcateName = json['SkillSubcateName'];
    fileName = json['FileName'];
    preLocation = json['PreLocation'];
    employmentType = json['Employmenttype'];
    natureOfJob = json['NatureOfJob'];
    workExperience = json['WorkExperience'];
    NoOfExpYear = json['NoOfExperienceYear'];
    jobTitleId1 = json['JobTitleId1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventName_ENG'] = this.eventName;
    data['JobPostId'] = this.jobPostId;
    data['JobPositionTitle_ENG'] = this.jobPosition;
    data['Male_NoOfVacancy'] = this.maleVacancy;
    data['Female_NoOfVacancy'] = this.femaleVacancy;
    data['Other_NoOfVacancy'] = this.otherVacancy;
    data['Any_NoOfVacancy'] = this.anyVacancy;
    data['Description'] = this.desc;
    data['Closing_Date'] = this.closeDate;
    data['NCO_Code'] = this.ncoCode;
    data['JobNameEn'] = this.sectorName;
    data['JobSectorId'] = this.sectorID;
    data['Min_AgeLimit'] = this.minAgeLimit;
    data['Max_AgeLimit'] = this.maxAgeLimit;
    data['MinSalary'] = this.minSalary;
    data['MaxSalary'] = this.maxSalary;
    data['EventID'] = this.eventID;
    data['SkillSetId'] = this.skillSetId;
    data['PostCreationDate'] = this.postCreationDate;
    data['EducationalDetailsId'] = this.educationalDetailsId;
    data['Start_Dates'] = this.startDates;
    data['JobTitleId'] = this.jobTitleId;
    data['StartDateStatus'] = this.startDateStatus;
    data['Today'] = this.today;
    data['Qualification_ENG'] = this.qualification;
    data['SkillNameEn'] = this.skillName;
    data['GraducationTypeID'] = this.graducationTypeID;
    data['SkillSubCateId'] = this.skillSubCateId;
    data['SkillSubcateName'] = this.skillSubcateName;
    data['FileName'] = this.fileName;
    data['PreLocation'] = this.preLocation;
    data['Employmenttype'] = this.employmentType;
    data['NatureOfJob'] = this.natureOfJob;
    data['WorkExperience'] = this.workExperience;
    data['NoOfExperienceYear'] = this.NoOfExpYear;
    data['JobTitleId1'] = this.jobTitleId1;
    return data;
  }
}
