class ProfileLanguageInfoModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ProfileLanguageInfoData>? data;

  ProfileLanguageInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ProfileLanguageInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ProfileLanguageInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new ProfileLanguageInfoData.fromJson(v));
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

class ProfileLanguageInfoData {
  dynamic languageDetailID;
  dynamic jobSeekerID;
  dynamic languageName;
  dynamic proficiencyName;
  dynamic proficiencyID;
  dynamic languageID;
  dynamic readStatus;
  dynamic writeStatus;
  dynamic speakStatus;
  dynamic isActive;
  dynamic languageDetailID1;

  ProfileLanguageInfoData(
      {this.languageDetailID,
        this.jobSeekerID,
        this.languageName,
        this.proficiencyName,
        this.proficiencyID,
        this.languageID,
        this.readStatus,
        this.writeStatus,
        this.speakStatus,
        this.isActive,
        this.languageDetailID1});

  ProfileLanguageInfoData.fromJson(Map<String, dynamic> json) {
    languageDetailID = json['LanguageDetailID'];
    jobSeekerID = json['JobSeekerID'];
    languageName = json['LanguageName'];
    proficiencyName = json['ProficiencyName'];
    proficiencyID = json['ProficiencyID'];
    languageID = json['LanguageID'];
    readStatus = json['ReadStatus'];
    writeStatus = json['WriteStatus'];
    speakStatus = json['SpeakStatus'];
    isActive = json['IsActive'];
    languageDetailID1 = json['LanguageDetailID1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LanguageDetailID'] = this.languageDetailID;
    data['JobSeekerID'] = this.jobSeekerID;
    data['LanguageName'] = this.languageName;
    data['ProficiencyName'] = this.proficiencyName;
    data['ProficiencyID'] = this.proficiencyID;
    data['LanguageID'] = this.languageID;
    data['ReadStatus'] = this.readStatus;
    data['WriteStatus'] = this.writeStatus;
    data['SpeakStatus'] = this.speakStatus;
    data['IsActive'] = this.isActive;
    data['LanguageDetailID1'] = this.languageDetailID1;
    return data;
  }
}
