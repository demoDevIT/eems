class ProfileQualicationInfoListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ProfileQualicationInfoData>? data;

  ProfileQualicationInfoListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ProfileQualicationInfoListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ProfileQualicationInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new ProfileQualicationInfoData.fromJson(v));
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

class ProfileQualicationInfoData {
  dynamic educationID;
  dynamic userID;
  dynamic hightestEducationLevelID;
  dynamic streamName;
  dynamic qualificationName;
  dynamic classID;
  dynamic collegeName;
  dynamic schoolName;
  dynamic passingYear;
  dynamic percentage;
  dynamic gradeID;
  dynamic className;
  dynamic gradeName;
  dynamic courseName;
  dynamic cGPA;
  dynamic hightestEducationLevelID1;
  dynamic educationTypeID;
  dynamic streamID;
  dynamic mediumID;
  dynamic courseNature;
  dynamic universityName;
  dynamic mediumName;
  dynamic educationTypeName;
  dynamic boardID;
  dynamic boardName;
  dynamic universityID;
  dynamic resultTypeName;
  dynamic resultType;
  dynamic nCOCode;
  dynamic nCO;

  ProfileQualicationInfoData(
      {this.educationID,
        this.userID,
        this.hightestEducationLevelID,
        this.streamName,
        this.qualificationName,
        this.classID,
        this.collegeName,
        this.schoolName,
        this.passingYear,
        this.percentage,
        this.gradeID,
        this.className,
        this.gradeName,
        this.courseName,
        this.cGPA,
        this.hightestEducationLevelID1,
        this.educationTypeID,
        this.streamID,
        this.mediumID,
        this.courseNature,
        this.universityName,
        this.mediumName,
        this.educationTypeName,
        this.boardID,
        this.boardName,
        this.universityID,
        this.resultTypeName,
        this.resultType,
        this.nCOCode,
        this.nCO});

  ProfileQualicationInfoData.fromJson(Map<String, dynamic> json) {
    educationID = json['EducationID'];
    userID = json['UserID'];
    hightestEducationLevelID = json['HightestEducationLevelID'];
    streamName = json['StreamName'];
    qualificationName = json['QualificationName'];
    classID = json['ClassID'];
    collegeName = json['CollegeName'];
    schoolName = json['SchoolName'];
    passingYear = json['PassingYear'];
    percentage = json['Percentage'];
    gradeID = json['GradeID'];
    className = json['ClassName'];
    gradeName = json['GradeName'];
    courseName = json['CourseName'];
    cGPA = json['CGPA'];
    hightestEducationLevelID1 = json['HightestEducationLevelID1'];
    educationTypeID = json['EducationTypeID'];
    streamID = json['StreamID'];
    mediumID = json['MediumID'];
    courseNature = json['CourseNature'];
    universityName = json['UniversityName'];
    mediumName = json['MediumName'];
    educationTypeName = json['EducationTypeName'];
    boardID = json['BoardID'];
    boardName = json['BoardName'];
    universityID = json['UniversityID'];
    resultTypeName = json['ResultTypeName'];
    resultType = json['ResultType'];
    nCOCode = json['NCOCode'];
    nCO = json['NCO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EducationID'] = this.educationID;
    data['UserID'] = this.userID;
    data['HightestEducationLevelID'] = this.hightestEducationLevelID;
    data['StreamName'] = this.streamName;
    data['QualificationName'] = this.qualificationName;
    data['ClassID'] = this.classID;
    data['CollegeName'] = this.collegeName;
    data['SchoolName'] = this.schoolName;
    data['PassingYear'] = this.passingYear;
    data['Percentage'] = this.percentage;
    data['GradeID'] = this.gradeID;
    data['ClassName'] = this.className;
    data['GradeName'] = this.gradeName;
    data['CourseName'] = this.courseName;
    data['CGPA'] = this.cGPA;
    data['HightestEducationLevelID1'] = this.hightestEducationLevelID1;
    data['EducationTypeID'] = this.educationTypeID;
    data['StreamID'] = this.streamID;
    data['MediumID'] = this.mediumID;
    data['CourseNature'] = this.courseNature;
    data['UniversityName'] = this.universityName;
    data['MediumName'] = this.mediumName;
    data['EducationTypeName'] = this.educationTypeName;
    data['BoardID'] = this.boardID;
    data['BoardName'] = this.boardName;
    data['UniversityID'] = this.universityID;
    data['ResultTypeName'] = this.resultTypeName;
    data['ResultType'] = this.resultType;
    data['NCOCode'] = this.nCOCode;
    data['NCO'] = this.nCO;
    return data;
  }
}
