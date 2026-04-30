class CounselorInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CounselorInfoData>? data;

  CounselorInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CounselorInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CounselorInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new CounselorInfoData.fromJson(v));
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

class CounselorInfoData {
  dynamic counsellorID;
  dynamic firstName;
  dynamic gender;
  dynamic dob;
  dynamic mobileNo;
  dynamic email;
  dynamic langID;
  dynamic nameENG;
  dynamic specExpertID;
  dynamic specName;
  dynamic adminDept;
  dynamic employmentID;
  dynamic SIPFHRMSNo;
  dynamic desigID;
  dynamic dateOfJoin;
  dynamic dateOfRetire;
  dynamic yearProfExp;
  dynamic postDeptName;
  dynamic eduQualID;
  dynamic qualiENG;
  dynamic degreeName;
  dynamic specSubject;
  dynamic univerInstiName;
  dynamic eduPassYearID;
  dynamic eduPassName;
  dynamic addiQualification;
  dynamic priDomExpertID;
  dynamic priDomExpertID1;
  dynamic priDomExpertName;
  dynamic certifiCourseComplete;
  dynamic certifiName;
  dynamic issueOrganization;
  dynamic yearCompID;
  dynamic yearCompName;
  dynamic langProfID;
  dynamic langProfName;
  dynamic counsMedID;
  dynamic counsName;
  dynamic techToolProfID;
  dynamic techToolName;
  dynamic yearExpCouns;
  dynamic publishWorkArt;
  dynamic linkedInPortURL;
  dynamic trainWorkConduct;
  dynamic availUpskill;
  dynamic prefAgeGroupForCounsID;
  dynamic prefAgeGroupForCounsName;
  dynamic freePsychoTest;
  dynamic clinicPsyco;
  dynamic profileImg;
  dynamic degreeID;
  dynamic otherDegreeName;
  dynamic univerID;
  dynamic privateStateID;
  dynamic privateDistrictID;
  dynamic privateCityID;
  dynamic isResidentState;

  CounselorInfoData(
      {
        this.counsellorID,
        this.firstName,
        this.gender,
        this.dob,
        this.mobileNo,
        this.email,
        this.langID,
        this.nameENG,
        this.specExpertID,
        this.specName,
        this.adminDept,
        this.employmentID,
        this.SIPFHRMSNo,
        this.desigID,
        this.dateOfJoin,
        this.dateOfRetire,
        this.yearProfExp,
        this.postDeptName,
        this.eduQualID,
        this.qualiENG,
        this.degreeName,
        this.specSubject,
        this.univerInstiName,
        this.eduPassYearID,
        this.eduPassName,
        this.addiQualification,
        this.priDomExpertID,
        this.priDomExpertID1,
        this.priDomExpertName,
        this.certifiCourseComplete,
        this.certifiName,
        this.issueOrganization,
        this.yearCompID,
        this.yearCompName,
        this.langProfID,
        this.langProfName,
        this.counsMedID,
        this.counsName,
        this.techToolProfID,
        this.techToolName,
        this.yearExpCouns,
        this.publishWorkArt,
        this.linkedInPortURL,
        this.trainWorkConduct,
        this.availUpskill,
        this.prefAgeGroupForCounsID,
        this.prefAgeGroupForCounsName,
        this.freePsychoTest,
        this.clinicPsyco,
        this.profileImg,
        this.degreeID,
        this.otherDegreeName,
        this.univerID,
        this.privateStateID,
        this.privateDistrictID,
        this.privateCityID,
        this.isResidentState,
      });

  CounselorInfoData.fromJson(Map<String, dynamic> json) {
    counsellorID = json['CounsellorID'];
    firstName = json['FirstName'];
    gender = json['Gender'];
    dob = json['DOB'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
    langID = json['LanguageID'];
    nameENG = json['Name_ENG'];
    specExpertID = json['Specialization_ExpertiseID'];
    specName = json['SpecializationName'];
    adminDept = json['AdministrativedepartmentName'];
    employmentID = json['EmploymentID'];
    SIPFHRMSNo = json['SIPFHRMSNumber'];
    desigID = json['DesignationID'];
    dateOfJoin = json['Dateofjoining'];
    dateOfRetire = json['DateofRetirement'];
    yearProfExp = json['YearOfProfessionalExperience'];
    postDeptName = json['PostedDepartmentName'];
    eduQualID = json['EducationQualificationID'];
    qualiENG = json['Qualification_ENG'];
    degreeName = json['DegreeName'];
    specSubject = json['Specialization_Subject'];
    univerInstiName = json['UniversityInstitutionName'];
    eduPassYearID = json['EducationPassingYearID'];
    eduPassName = json['EducationPassingName'];
    addiQualification = json['Additional_Qualificate'];
    priDomExpertID = json['PrimaryDomainExpertiseID'];
    priDomExpertID1 = json['PrimaryDomainExpertiseID1'];
    priDomExpertName = json['PrimaryDomainExpertiesName'];
    certifiCourseComplete = json['Certifications_CoursesCompleted'];
    certifiName = json['CertificationName'];
    issueOrganization = json['IssuingOrganization'];
    yearCompID = json['YearOfCompletionID'];
    yearCompName = json['YearOfCompletionName'];
    langProfID = json['LanguageProficiencyID'];
    langProfName = json['LanguageProficiencyName'];
    counsMedID = json['CounselingMediumID'];
    counsName = json['CounsellingName'];
    techToolProfID = json['TechnicalToolsProficiencyID'];
    techToolName = json['TechnicalToolsName'];
    yearExpCouns = json['YearsOfExperienceInCounseling'];
    publishWorkArt = json['PublishedWorkArticles'];
    linkedInPortURL = json['LinkedIn_PortfolioURL'];
    trainWorkConduct = json['Training_WorkshopConducted'];
    availUpskill = json['AvailibiltyForUpskilling'];
    prefAgeGroupForCounsID = json['PreferredAgeGroupForCounselingID'];
    prefAgeGroupForCounsName = json['PreferredAgeGroupForCounselingName'];
    freePsychoTest = json['FreePsychometricTests'];
    clinicPsyco = json['ClinicalPsychologist'];
    profileImg = json['ProfileImageUrl'];
    degreeID = json['DegreeID'];
    otherDegreeName = json['OtherDegreeName'];
    univerID = json['UniversityID'];
    privateStateID = json['PrivateStateID'];
    privateDistrictID = json['PrivateDistrictID'];
    privateCityID = json['PrivateCityID'];
    isResidentState = json['IsResidentState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CounsellorID'] = this.counsellorID;
    data['FirstName'] = this.firstName;
    data['Gender'] = this.gender;
    data['DOB'] = this.dob;
    data['MobileNo'] = this.mobileNo;
    data['Email'] = this.email;
    data['LanguageID'] = this.langID;
    data['Name_ENG'] = this.nameENG;
    data['Specialization_ExpertiseID'] = this.specExpertID;
    data['SpecializationName'] = this.specName;
    data['AdministrativedepartmentName'] = this.adminDept;
    data['EmploymentID'] = this.employmentID;
    data['SIPFHRMSNumber'] = this.SIPFHRMSNo;
    data['DesignationID'] = this.desigID;
    data['Dateofjoining'] = this.dateOfJoin;
    data['DateofRetirement'] = this.dateOfRetire;
    data['YearOfProfessionalExperience'] = this.yearProfExp;
    data['PostedDepartmentName'] = this.postDeptName;
    data['EducationQualificationID'] = this.eduQualID;
    data['Qualification_ENG'] = this.qualiENG;
    data['DegreeName'] = this.degreeName;
    data['Specialization_Subject'] = this.specSubject;
    data['UniversityInstitutionName'] = this.univerInstiName;
    data['EducationPassingYearID'] = this.eduPassYearID;
    data['EducationPassingName'] = this.eduPassName;
    data['Additional_Qualificate'] = this.addiQualification;
    data['PrimaryDomainExpertiseID'] = this.priDomExpertID;
    data['PrimaryDomainExpertiseID1'] = this.priDomExpertID1;
    data['PrimaryDomainExpertiesName'] = this.priDomExpertName;
    data['Certifications_CoursesCompleted'] = this.certifiCourseComplete;
    data['CertificationName'] = this.certifiName;
    data['IssuingOrganization'] = this.issueOrganization;
    data['YearOfCompletionID'] = this.yearCompID;
    data['YearOfCompletionName'] = this.yearCompName;
    data['LanguageProficiencyID'] = this.langProfID;
    data['LanguageProficiencyName'] = this.langProfName;
    data['CounselingMediumID'] = this.counsMedID;
    data['CounsellingName'] = this.counsName;
    data['TechnicalToolsProficiencyID'] = this.techToolProfID;
    data['TechnicalToolsName'] = this.techToolName;
    data['YearsOfExperienceInCounseling'] = this.yearExpCouns;
    data['PublishedWorkArticles'] = this.publishWorkArt;
    data['LinkedIn_PortfolioURL'] = this.linkedInPortURL;
    data['Training_WorkshopConducted'] = this.trainWorkConduct;
    data['AvailibiltyForUpskilling'] = this.availUpskill;
    data['PreferredAgeGroupForCounselingID'] = this.prefAgeGroupForCounsID;
    data['PreferredAgeGroupForCounselingName'] = this.prefAgeGroupForCounsName;
    data['FreePsychometricTests'] = this.freePsychoTest;
    data['ClinicalPsychologist'] = this.clinicPsyco;
    data['ProfileImageUrl'] = this.profileImg;
    data['DegreeID'] = this.degreeID;
    data['OtherDegreeName'] = this.otherDegreeName;
    data['UniversityID'] = this.univerID;
    data['PrivateStateID'] = this.privateStateID;
    data['PrivateDistrictID'] = this.privateDistrictID;
    data['PrivateCityID'] = this.privateCityID;
    data['IsResidentState'] = this.isResidentState;
    return data;
  }
}
