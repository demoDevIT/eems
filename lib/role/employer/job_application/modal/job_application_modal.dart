class JobApplicationModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<JobApplicationData>? data;

  JobApplicationModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobApplicationModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobApplicationData>[];
      json['Data'].forEach((v) {
        data!.add(JobApplicationData.fromJson(v));
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

class JobApplicationData {
  dynamic appPKID;
  dynamic jobPostId;
  dynamic name;
  dynamic fullName;
  dynamic jobPositionTitle;
  dynamic eventId;
  dynamic isEventStarted;
  dynamic jobSeekerId;
  dynamic flag;
  dynamic email;
  dynamic mobileNo;
  dynamic candidateStatus;

  JobApplicationData(
      {this.appPKID,
        this.jobPostId,
        this.name,
        this.fullName,
        this.jobPositionTitle,
        this.eventId,
        this.isEventStarted,
        this.jobSeekerId,
        this.flag,
        this.email,
        this.mobileNo,
        this.candidateStatus,
      });

  JobApplicationData.fromJson(Map<String, dynamic> json) {
    appPKID = json['applicantPKID'];
    jobPostId = json['JobPostId'];
    name = json['Name_eng'];
    fullName = json['FullName'];
    jobPositionTitle = json['JobPositionTitle_ENG'];
    eventId = json['EventId'];
    isEventStarted = json['IsEventStarted'];
    jobSeekerId = json['JobSeekerId'];
    flag = json['Flag'];
    email = json['Email_ID'];
    mobileNo = json['Mobile_no'];
    candidateStatus = json['CandidateStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicantPKID'] = this.appPKID;
    data['JobPostId'] = this.jobPostId;
    data['Name_eng'] = this.name;
    data['FullName'] = this.fullName;
    data['JobPositionTitle_ENG'] = this.jobPositionTitle;
    data['EventId'] = this.eventId;
    data['IsEventStarted'] = this.isEventStarted;
    data['JobSeekerId'] = this.jobSeekerId;
    data['Flag'] = this.flag;
    data['Email_ID'] = this.email;
    data['Mobile_no'] = this.mobileNo;
    data['CandidateStatus'] = this.candidateStatus;
    return data;
  }
}
