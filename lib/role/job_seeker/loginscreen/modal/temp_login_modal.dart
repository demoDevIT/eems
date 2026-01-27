class TempLoginModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  TempLoginData? data;

  TempLoginModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  TempLoginModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new TempLoginData.fromJson(json['Data']) : null;
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

class TempLoginData {
  dynamic profileID;
  dynamic userID;
  dynamic roleID;
  dynamic applicationID;
  dynamic applicationFinalSubmit;
  dynamic sSOID;
  dynamic aadhaarID;
  dynamic bhamashahId;
  dynamic bhamashahMemberId;
  dynamic displayName;
  dynamic dateOfBirth;
  dynamic gender;
  dynamic mobileno;
  dynamic telephoneNumber;
  dynamic ipPhone;
  dynamic mailPersonal;
  dynamic postalAddress;
  dynamic postalCode;
  dynamic city;
  dynamic state;
  dynamic photo;
  dynamic designation;
  dynamic departmentName;
  dynamic mailOfficial;
  dynamic employeeNumber;
  dynamic departmentID;
  dynamic firstName;
  dynamic lastName;
  dynamic sldSSOIDs;
  dynamic janaadhaarId;
  dynamic manaadhaarMemberId;
  dynamic userType;
  dynamic mfa;
  dynamic instituteID;
  dynamic studentID;
  dynamic instituteName;
  dynamic engNonEng;
  dynamic engNonEngName;
  dynamic financialYearID;
  dynamic endTermID;
  dynamic financialYearIDSession;
  dynamic endTermIDSession;
  dynamic hostelID;
  dynamic hostelIDs;
  dynamic userRequestStatus;
  dynamic loginStatus;
  dynamic isCitizenQueryUser;
  dynamic queryType;
  dynamic staffID;
  dynamic examScheme;
  dynamic encryptedSSOID;
  dynamic searchRecordID;

  TempLoginData(
      {this.profileID,
        this.userID,
        this.roleID,
        this.applicationID,
        this.applicationFinalSubmit,
        this.sSOID,
        this.aadhaarID,
        this.bhamashahId,
        this.bhamashahMemberId,
        this.displayName,
        this.dateOfBirth,
        this.gender,
        this.mobileno,
        this.telephoneNumber,
        this.ipPhone,
        this.mailPersonal,
        this.postalAddress,
        this.postalCode,
        this.city,
        this.state,
        this.photo,
        this.designation,
        this.departmentName,
        this.mailOfficial,
        this.employeeNumber,
        this.departmentID,
        this.firstName,
        this.lastName,
        this.sldSSOIDs,
        this.janaadhaarId,
        this.manaadhaarMemberId,
        this.userType,
        this.mfa,
        this.instituteID,
        this.studentID,
        this.instituteName,
        this.engNonEng,
        this.engNonEngName,
        this.financialYearID,
        this.endTermID,
        this.financialYearIDSession,
        this.endTermIDSession,
        this.hostelID,
        this.hostelIDs,
        this.userRequestStatus,
        this.loginStatus,
        this.isCitizenQueryUser,
        this.queryType,
        this.staffID,
        this.examScheme,
        this.encryptedSSOID,
        this.searchRecordID});

  TempLoginData.fromJson(Map<String, dynamic> json) {
    profileID = json['ProfileID'];
    userID = json['UserID'];
    roleID = json['RoleID'];
    applicationID = json['ApplicationID'];
    applicationFinalSubmit = json['ApplicationFinalSubmit'];
    sSOID = json['SSOID'];
    aadhaarID = json['AadhaarID'];
    bhamashahId = json['BhamashahId'];
    bhamashahMemberId = json['BhamashahMemberId'];
    displayName = json['DisplayName'];
    dateOfBirth = json['DateOfBirth'];
    gender = json['Gender'];
    mobileno = json['Mobileno'];
    telephoneNumber = json['TelephoneNumber'];
    ipPhone = json['IpPhone'];
    mailPersonal = json['MailPersonal'];
    postalAddress = json['PostalAddress'];
    postalCode = json['PostalCode'];
    city = json['City'];
    state = json['State'];
    photo = json['Photo'];
    designation = json['Designation'];
    departmentName = json['DepartmentName'];
    mailOfficial = json['MailOfficial'];
    employeeNumber = json['EmployeeNumber'];
    departmentID = json['DepartmentID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    sldSSOIDs = json['SldSSOIDs'];
    janaadhaarId = json['JanaadhaarId'];
    manaadhaarMemberId = json['ManaadhaarMemberId'];
    userType = json['UserType'];
    mfa = json['Mfa'];
    instituteID = json['InstituteID'];
    studentID = json['StudentID'];
    instituteName = json['InstituteName'];
    engNonEng = json['Eng_NonEng'];
    engNonEngName = json['Eng_NonEngName'];
    financialYearID = json['FinancialYearID'];
    endTermID = json['EndTermID'];
    financialYearIDSession = json['FinancialYearID_Session'];
    endTermIDSession = json['EndTermID_Session'];
    hostelID = json['HostelID'];
    hostelIDs = json['HostelIDs'];
    userRequestStatus = json['UserRequestStatus'];
    loginStatus = json['LoginStatus'];
    isCitizenQueryUser = json['IsCitizenQueryUser'];
    queryType = json['QueryType'];
    staffID = json['StaffID'];
    examScheme = json['ExamScheme'];
    encryptedSSOID = json['Encrypted_SSOID'];
    searchRecordID = json['SearchRecordID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProfileID'] = this.profileID;
    data['UserID'] = this.userID;
    data['RoleID'] = this.roleID;
    data['ApplicationID'] = this.applicationID;
    data['ApplicationFinalSubmit'] = this.applicationFinalSubmit;
    data['SSOID'] = this.sSOID;
    data['AadhaarID'] = this.aadhaarID;
    data['BhamashahId'] = this.bhamashahId;
    data['BhamashahMemberId'] = this.bhamashahMemberId;
    data['DisplayName'] = this.displayName;
    data['DateOfBirth'] = this.dateOfBirth;
    data['Gender'] = this.gender;
    data['Mobileno'] = this.mobileno;
    data['TelephoneNumber'] = this.telephoneNumber;
    data['IpPhone'] = this.ipPhone;
    data['MailPersonal'] = this.mailPersonal;
    data['PostalAddress'] = this.postalAddress;
    data['PostalCode'] = this.postalCode;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Photo'] = this.photo;
    data['Designation'] = this.designation;
    data['DepartmentName'] = this.departmentName;
    data['MailOfficial'] = this.mailOfficial;
    data['EmployeeNumber'] = this.employeeNumber;
    data['DepartmentID'] = this.departmentID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['SldSSOIDs'] = this.sldSSOIDs;
    data['JanaadhaarId'] = this.janaadhaarId;
    data['ManaadhaarMemberId'] = this.manaadhaarMemberId;
    data['UserType'] = this.userType;
    data['Mfa'] = this.mfa;
    data['InstituteID'] = this.instituteID;
    data['StudentID'] = this.studentID;
    data['InstituteName'] = this.instituteName;
    data['Eng_NonEng'] = this.engNonEng;
    data['Eng_NonEngName'] = this.engNonEngName;
    data['FinancialYearID'] = this.financialYearID;
    data['EndTermID'] = this.endTermID;
    data['FinancialYearID_Session'] = this.financialYearIDSession;
    data['EndTermID_Session'] = this.endTermIDSession;
    data['HostelID'] = this.hostelID;
    data['HostelIDs'] = this.hostelIDs;
    data['UserRequestStatus'] = this.userRequestStatus;
    data['LoginStatus'] = this.loginStatus;
    data['IsCitizenQueryUser'] = this.isCitizenQueryUser;
    data['QueryType'] = this.queryType;
    data['StaffID'] = this.staffID;
    data['ExamScheme'] = this.examScheme;
    data['Encrypted_SSOID'] = this.encryptedSSOID;
    data['SearchRecordID'] = this.searchRecordID;
    return data;
  }
}
