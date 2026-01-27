// sector dropdown list
class AllJobSectorListModal {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<AllJobSectorData>? data;

  AllJobSectorListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  AllJobSectorListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <AllJobSectorData>[];
      json['Data'].forEach((v) {
        data!.add(new AllJobSectorData.fromJson(v));
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

class AllJobSectorData {
  int? id;
  String? nameEng;
  String? nameHi;

  AllJobSectorData(
      {
        this.id,
        this.nameEng,
        this.nameHi
      });

  AllJobSectorData.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nameEng = json['Name_ENG'];
    nameHi = json['Name_ENG1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Name_ENG'] = this.nameEng;
    data['Name_ENG1'] = this.nameHi;

    return data;
  }
}

// title dropdown list
class AllJobTitleListModal {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<AllJobTitleData>? data;

  AllJobTitleListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  AllJobTitleListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <AllJobTitleData>[];
      json['Data'].forEach((v) {
        data!.add(new AllJobTitleData.fromJson(v));
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

class AllJobTitleData {
  // dynamic eventId;
  // dynamic startDate;
  // dynamic endDate;
  // dynamic jobTitle;
  // dynamic jobPosition;
  int? id;
  String? nameEng;
  String? nameHi;

  AllJobTitleData(
      {
        // this.eventId,
        // this.startDate,
        // this.endDate,
        // this.jobTitle,
        // this.jobPosition,

        this.id,
        this.nameEng,
        this.nameHi
      });

  AllJobTitleData.fromJson(Map<String, dynamic> json) {
    // eventId = json['EventId'];
    // startDate = json['StartDate'];
    // endDate = json['EndDate'];
    // jobTitle = json['JobTitle'];
    // jobPosition = json['JobPositionTiel_HI'];

    id = json['ID'];
    nameEng = json['Name_ENG'];
    nameHi = json['Name_ENG1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['EventId'] = this.eventId;
    // data['StartDate'] = this.startDate;
    // data['EndDate'] = this.endDate;
    // data['JobTitle'] = this.jobTitle;
    // data['JobPositionTiel_HI'] = this.jobPosition;

    data['ID'] = this.id;
    data['Name_ENG'] = this.nameEng;
    data['Name_ENG1'] = this.nameHi;

    return data;
  }
}


// applied and all Job List
class AppliedJobListModal {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<AppliedJobData>? data;

  AppliedJobListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  AppliedJobListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <AppliedJobData>[];
      json['Data'].forEach((v) {
        data!.add(new AppliedJobData.fromJson(v));
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

class AppliedJobData {
  int? employerID;           // ✅ REQUIRED
  int? jobPostId;
  int? eventid;              // ✅ REQUIRED
  String? companyName;
  String? logo;
  String? jobsector;
  String? jobtitle;
  int? totalVacancy;
  String? preLocation;
  int? isAlreadyApplied;     // ✅ NEW KEY
  int? maxApply;
  int? PreferencesId;// ✅ NEW KEY

  AppliedJobData({
    this.employerID,
    this.jobPostId,
    this.eventid,
    this.companyName,
    this.logo,
    this.jobsector,
    this.jobtitle,
    this.totalVacancy,
    this.preLocation,
    this.isAlreadyApplied,
    this.maxApply,
    this.PreferencesId
  });

  AppliedJobData.fromJson(Map<String, dynamic> json) {
    employerID = json['EmployerID'];              // ✅
    jobPostId = json['JobPostId'];
    eventid = json['eventid'];                    // ✅
    companyName = json['CompanyName'];
    logo = json['Logo'];
    jobsector = json['jobsector'];
    jobtitle = json['jobtitle'];
    totalVacancy = json['TotalVacany'];
    preLocation = json['PreLocation'];
    isAlreadyApplied = json['IsAlreadyApplied'];
    maxApply = json['MaxApply'];
    PreferencesId = json['PreferencesId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['EmployerID'] = employerID;
    data['JobPostId'] = jobPostId;
    data['eventid'] = eventid;
    data['CompanyName'] = companyName;
    data['Logo'] = logo;
    data['jobsector'] = jobsector;
    data['jobtitle'] = jobtitle;
    data['TotalVacany'] = totalVacancy;
    data['PreLocation'] = preLocation;
    data['IsAlreadyApplied'] = isAlreadyApplied;
    data['MaxApply'] = maxApply;
    data['PreferencesId'] = PreferencesId;

    return data;
  }
}

