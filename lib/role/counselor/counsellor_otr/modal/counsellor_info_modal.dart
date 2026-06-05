class CounsellorInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CounsellorInfoData>? data;

  CounsellorInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CounsellorInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CounsellorInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new CounsellorInfoData.fromJson(v));
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

class CounsellorInfoData {
  dynamic counsellorID;
  dynamic firstName;
  dynamic dob;
  dynamic name;
  dynamic mobileNo;
  dynamic gender;
  dynamic email;
  dynamic languageID;
  dynamic specExpID;
  dynamic employmentID;
  dynamic OrgName;
  dynamic designationID;
  dynamic yearOfProfExp;
  dynamic areaOfProfExp;
  dynamic uploadExpuLetterCertu;
  dynamic uploadProfID;
  dynamic affiliatedWithAnyCareerID;
  dynamic eduQualID;
  dynamic degreeName;
  dynamic specSub;
  dynamic additionalQualificate;
  dynamic educationPassingYearID;
  dynamic uploadDegreeCert;
  dynamic primaryDomainExpID;
  dynamic certCoursesComp;
  dynamic certName;
  dynamic issuingOrganization;
  dynamic yearOfCompID;
  dynamic uploadDegreeCertYearOfComp;
  dynamic langProfID;
  dynamic counselingMediumID;
  dynamic techToolsProfID;
  dynamic yearsOfExpInCounseling;
  dynamic publishedWorkArticles;
  dynamic linkedInPortfolioURL;
  dynamic trainingWorkshopConducted;
  dynamic availForUpskilling;
  dynamic prefAgeGroupForCounselingID;
  dynamic conditionCheckbox;
  dynamic employeeType;
  dynamic isPresentEmp;
  dynamic isDivCounsellorType;
  dynamic isPreGovtEmp;
  dynamic iscounselorType;
  dynamic showEmpIDField;
  dynamic empID;
  dynamic ppoNumber;
  dynamic isJanIDShow;
  dynamic ssoID;
  dynamic userID;
  dynamic counselorID;
  dynamic uidTypeID;
  dynamic uidNumber;
  dynamic fatherName;
  dynamic employmentStatusID;
  dynamic qualificationID;
  dynamic occupationName;
  dynamic stateID;
  dynamic districtCode;
  dynamic pinCode;
  dynamic disclaimerStatus;
  dynamic userId;
  dynamic residentStateID;
  dynamic empTypeID;
  dynamic presentEmpID;
  dynamic empNumber;
  dynamic janAadhaarNo;
  dynamic aadhaarNo;
  dynamic janmenID;
  dynamic enrID;
  dynamic regNo;
  dynamic Admindept;
  dynamic sipfHRMSNumber;
  dynamic dateofjoining;
  dynamic dateofRetirement;
  dynamic postedDepartmentName;
  dynamic empTypeName;
  dynamic universityInstitutionName;
  dynamic isResidentState;
  dynamic divIsPresentGovtEmploye;
  dynamic divIsPresentPrivateEmploye;
  dynamic isPresentGovtEmployee;
  dynamic districtId;
  dynamic category;
  dynamic clinicalPsychologist;
  dynamic freePsychometricTests;
  dynamic profileImageUrl;
  dynamic degreeID;
  dynamic universityID;
  dynamic otherDegreeName;
  dynamic privateDistrictID;
  dynamic privateStateID;
  dynamic privateCityID;

  CounsellorInfoData(
      {this.counsellorID,
        this.firstName,
        this.dob,
        this.name,
        this.mobileNo,
        this.gender,
        this.email,
        this.languageID,
        this.specExpID,
        this.employmentID,
        this.OrgName,
        this.designationID,
        this.yearOfProfExp,
        this.areaOfProfExp,
        this.uploadExpuLetterCertu,
        this.uploadProfID,
        this.affiliatedWithAnyCareerID,
        this.eduQualID,
        this.degreeName,
        this.specSub,
        this.additionalQualificate,
        this.educationPassingYearID,
        this.uploadDegreeCert,
        this.primaryDomainExpID,
        this.certCoursesComp,
        this.certName,
        this.issuingOrganization,
        this.yearOfCompID,
        this.uploadDegreeCertYearOfComp,
        this.langProfID,
        this.counselingMediumID,
        this.techToolsProfID,
        this.yearsOfExpInCounseling,
        this.publishedWorkArticles,
        this.linkedInPortfolioURL,
        this.trainingWorkshopConducted,
        this.availForUpskilling,
        this.prefAgeGroupForCounselingID,
        this.conditionCheckbox,
        this.employeeType,
        this.isPresentEmp,
        this.isDivCounsellorType,
        this.isPreGovtEmp,
        this.iscounselorType,
        this.showEmpIDField,
        this.empID,
        this.ppoNumber,
        this.isJanIDShow,
        this.ssoID,
        this.userID,
        this.counselorID,
        this.uidTypeID,
        this.uidNumber,
        this.fatherName,
        this.employmentStatusID,
        this.qualificationID,
        this.occupationName,
        this.stateID,
        this.districtCode,
        this.pinCode,
        this.disclaimerStatus,
        this.userId,
        this.residentStateID,
        this.empTypeID,
        this.presentEmpID,
        this.empNumber,
        this.janAadhaarNo,
        this.aadhaarNo,
        this.janmenID,
        this.enrID,
        this.regNo,
        this.Admindept,
        this.sipfHRMSNumber,
        this.dateofjoining,
        this.dateofRetirement,
        this.postedDepartmentName,
        this.empTypeName,
        this.universityInstitutionName,
        this.isResidentState,
        this.divIsPresentGovtEmploye,
        this.divIsPresentPrivateEmploye,
        this.isPresentGovtEmployee,
        this.districtId,
        this.category,
        this.clinicalPsychologist,
        this.freePsychometricTests,
        this.profileImageUrl,
        this.degreeID,
        this.universityID,
        this.otherDegreeName,
        this.privateDistrictID,
        this.privateStateID,
        this.privateCityID,
      });

  CounsellorInfoData.fromJson(Map<String, dynamic> json) {
    counsellorID = json['CounsellorID'];
    firstName = json['FirstName'];
    dob = json['DOB'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    gender = json['Gender'];
    email = json['Email'];
    languageID = json['LanguageID'];
    specExpID = json['Specialization_ExpertiseID'];
    employmentID = json['EmploymentID'];
    OrgName = json['OrganizationName'];
    designationID = json['DesignationID'];
    yearOfProfExp = json['YearOfProfessionalExperience'];
    areaOfProfExp = json['AreaOfProfessionalExpertise'];
    uploadExpuLetterCertu = json['UploadExperienceLetterCertificate'];
    uploadProfID = json['UploadProfessionalID'];
    affiliatedWithAnyCareerID = json['AffiliatedWithAnyCareerID'];
    eduQualID = json['EducationQualificationID'];
    degreeName = json['DegreeName'];
    specSub = json['Specialization_Subject'];
    additionalQualificate = json['Additional_Qualificate'];
    educationPassingYearID = json['EducationPassingYearID'];
    uploadDegreeCert = json['UploadDegreeCertificate'];
    primaryDomainExpID = json['PrimaryDomainExpertiseID'];
    certCoursesComp = json['Certifications_CoursesCompleted'];
    certName = json['CertificationName'];
    issuingOrganization = json['IssuingOrganization'];
    yearOfCompID = json['YearOfCompletionID'];
    uploadDegreeCertYearOfComp = json['UploadDegreeCertificateYearOfCompletion'];
    langProfID = json['LanguageProficiencyID'];
    counselingMediumID = json['CounselingMediumID'];
    techToolsProfID = json['TechnicalToolsProficiencyID'];
    yearsOfExpInCounseling = json['YearsOfExperienceInCounseling'];
    publishedWorkArticles = json['PublishedWorkArticles'];
    linkedInPortfolioURL = json['LinkedIn_PortfolioURL'];
    trainingWorkshopConducted = json['Training_WorkshopConducted'];
    availForUpskilling = json['AvailibiltyForUpskilling'];
    prefAgeGroupForCounselingID = json['PreferredAgeGroupForCounselingID'];
    conditionCheckbox = json['ConditionCheckbox'];
    employeeType = json['EmployeeType'];
    isPresentEmp = json['IsPresentEmployee'];
    isDivCounsellorType = json['IsDivCounsellorType'];
    isPreGovtEmp = json['IsPresentGovtEmploye'];
    iscounselorType = json['IscounselorType'];
    showEmpIDField = json['ShowEmployeIDField'];
    empID = json['EmployeeID'];
    ppoNumber = json['PPONumber'];
    isJanIDShow = json['IsJanIDShow'];
    ssoID = json['SSOID'];
    userID = json['UserID'];
    counselorID = json['CounselorID'];
    uidTypeID = json['UIDTypeID'];
    uidNumber = json['UIDNumber'];
    fatherName = json['FatherName'];
    employmentStatusID = json['EmploymentStatusID'];
    qualificationID = json['QualificationID'];
    occupationName = json['OccupationName'];
    stateID = json['StateID'];
    districtCode = json['DistrictCode'];
    pinCode = json['PinCode'];
    disclaimerStatus = json['DisclaimerStatus'];
    userId = json['UserId'];
    residentStateID = json['ResidentStateID'];
    empTypeID = json['EmployeeTypeID'];
    presentEmpID = json['PresentEmployeeID'];
    empNumber = json['EmployeeNumber'];
    janAadhaarNo = json['JanAadhaarNo'];
    aadhaarNo = json['AadhaarNo'];
    janmenID = json['JanmenID'];
    enrID = json['EnrID'];
    regNo = json['RegistrationNo'];
    Admindept = json['AdministrativedepartmentName'];
    sipfHRMSNumber = json['SIPFHRMSNumber'];
    dateofjoining = json['Dateofjoining'];
    dateofRetirement = json['DateofRetirement'];
    postedDepartmentName = json['PostedDepartmentName'];
    empTypeName = json['EmpTypeName'];
    universityInstitutionName = json['UniversityInstitutionName'];
    isResidentState = json['IsResidentState'];
    divIsPresentGovtEmploye = json['DivIsPresentGovtEmploye'];
    divIsPresentPrivateEmploye = json['DivIsPresentPrivateEmploye'];
    isPresentGovtEmployee = json['IsPresentGovtEmployee'];
    districtId = json['DistrictId'];
    category = json['category'];
    clinicalPsychologist = json['ClinicalPsychologist'];
    freePsychometricTests = json['FreePsychometricTests'];
    profileImageUrl = json['ProfileImageUrl'];
    degreeID = json['DegreeID'];
    universityID = json['UniversityID'];
    otherDegreeName = json['OtherDegreeName'];
    privateDistrictID = json['PrivateDistrictID'];
    privateStateID = json['PrivateStateID'];
    privateCityID = json['PrivateCityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CounsellorID'] = this.counsellorID;
    data['FirstName'] = this.firstName;
    data['DOB'] = this.dob;
    data['Name'] = this.name;
    data['MobileNo'] = this.mobileNo;
    data['Gender'] = this.gender;
    data['Email'] = this.email;
    data['LanguageID'] = this.languageID;
    data['Specialization_ExpertiseID'] = this.specExpID;
    data['EmploymentID'] = this.empID;
    data['OrganizationName'] = this.OrgName;
    data['DesignationID'] = this.designationID;
    data['YearOfProfessionalExperience'] = this.yearOfProfExp;
    data['AreaOfProfessionalExpertise'] = this.areaOfProfExp;
    data['UploadExperienceLetterCertificate'] = this.uploadExpuLetterCertu;
    data['UploadProfessionalID'] = this.uploadProfID;
    data['AffiliatedWithAnyCareerID'] = this.affiliatedWithAnyCareerID;
    data['EducationQualificationID'] = this.eduQualID;
    data['DegreeName'] = this.degreeName;
    data['Specialization_Subject'] = this.specSub;
    data['Additional_Qualificate'] = this.additionalQualificate;
    data['EducationPassingYearID'] = this.educationPassingYearID;
    data['UploadDegreeCertificate'] = this.uploadDegreeCert;
    data['PrimaryDomainExpertiseID'] = this.primaryDomainExpID;
    data['Certifications_CoursesCompleted'] = this.certCoursesComp;
    data['CertificationName'] = this.certName;
    data['IssuingOrganization'] = this.issuingOrganization;
    data['YearOfCompletionID'] = this.yearOfCompID;
    data['UploadDegreeCertificateYearOfCompletion'] = this.uploadDegreeCertYearOfComp;
    data['LanguageProficiencyID'] = this.langProfID;
    data['CounselingMediumID'] = this.counselingMediumID;
    data['TechnicalToolsProficiencyID'] = this.techToolsProfID;
    data['YearsOfExperienceInCounseling'] = this.yearsOfExpInCounseling;
    data['PublishedWorkArticles'] = this.publishedWorkArticles;
    data['LinkedIn_PortfolioURL'] = this.linkedInPortfolioURL;
    data['Training_WorkshopConducted'] = this.trainingWorkshopConducted;
    data['AvailibiltyForUpskilling'] = this.availForUpskilling;
    data['PreferredAgeGroupForCounselingID'] = this.prefAgeGroupForCounselingID;
    data['ConditionCheckbox'] = this.conditionCheckbox;
    data['EmployeeType'] = this.employeeType;
    data['IsPresentEmployee'] = this.isPresentEmp;
    data['IsDivCounsellorType'] = this.isDivCounsellorType;
    data['IsPresentGovtEmploye'] = this.isPreGovtEmp;
    data['IscounselorType'] = this.iscounselorType;
    data['ShowEmployeIDField'] = this.showEmpIDField;
    data['EmployeeID'] = this.empID;
    data['PPONumber'] = this.ppoNumber;
    data['IsJanIDShow'] = this.isJanIDShow;
    data['SSOID'] = this.ssoID;
    data['UserID'] = this.userID;
    data['CounselorID'] = this.counselorID;
    data['UIDTypeID'] = this.uidTypeID;
    data['UIDNumber'] = this.uidNumber;
    data['FatherName'] = this.fatherName;
    data['EmploymentStatusID'] = this.employmentStatusID;
    data['QualificationID'] = this.qualificationID;
    data['OccupationName'] = this.occupationName;
    data['StateID'] = this.stateID;
    data['DistrictCode'] = this.districtCode;
    data['PinCode'] = this.pinCode;
    data['DisclaimerStatus'] = this.disclaimerStatus;
    data['UserId'] = this.userId;
    data['ResidentStateID'] = this.residentStateID;
    data['EmployeeTypeID'] = this.empTypeID;
    data['PresentEmployeeID'] = this.presentEmpID;
    data['EmployeeNumber'] = this.empNumber;
    data['JanAadhaarNo'] = this.janAadhaarNo;
    data['AadhaarNo'] = this.aadhaarNo;
    data['JanmenID'] = this.janmenID;
    data['EnrID'] = this.enrID;
    data['RegistrationNo'] = this.regNo;
    data['AdministrativedepartmentName'] = this.Admindept;
    data['SIPFHRMSNumber'] = this.sipfHRMSNumber;
    data['Dateofjoining'] = this.dateofjoining;
    data['DateofRetirement'] = this.dateofRetirement;
    data['PostedDepartmentName'] = this.postedDepartmentName;
    data['EmpTypeName'] = this.empTypeName;
    data['UniversityInstitutionName'] = this.universityInstitutionName;
    data['IsResidentState'] = this.isResidentState;
    data['DivIsPresentGovtEmploye'] = this.divIsPresentGovtEmploye;
    data['DivIsPresentPrivateEmploye'] = this.divIsPresentPrivateEmploye;
    data['IsPresentGovtEmployee'] = this.isPresentGovtEmployee;
    data['DistrictId'] = this.districtId;
    data['category'] = this.category;
    data['ClinicalPsychologist'] = this.clinicalPsychologist;
    data['FreePsychometricTests'] = this.freePsychometricTests;
    data['ProfileImageUrl'] = this.profileImageUrl;
    data['DegreeID'] = this.degreeID;
    data['UniversityID'] = this.universityID;
    data['OtherDegreeName'] = this.otherDegreeName;
    data['PrivateDistrictID'] = this.privateDistrictID;
    data['PrivateStateID'] = this.privateStateID;
    data['PrivateCityID'] = this.privateCityID;
    return data;
  }
}
