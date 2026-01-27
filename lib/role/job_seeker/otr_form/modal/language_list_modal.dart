class LanguageListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<LanguageListData>? data;

  LanguageListModal({this.state, this.status, this.message, this.errorMessage, this.data});

  LanguageListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <LanguageListData>[];
      json['Data'].forEach((v) {
        data!.add(new LanguageListData.fromJson(v));
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

class LanguageListData {
  dynamic languageId;
  dynamic languageName;
  dynamic proficiencyId;
  dynamic proficiencyName;
  dynamic read;
  dynamic write;
  dynamic speak;
  dynamic checkRead;
  dynamic checkwrite;
  dynamic checkspeak;

  LanguageListData({this.languageId, this.languageName, this.proficiencyId,
    this.proficiencyName, this.read, this.write, this.speak, this.checkRead, this.checkwrite, this.checkspeak});

  LanguageListData.fromJson(Map<String, dynamic> json) {
    languageId = json['Language'];
    languageName = json['Proficiency'];
    proficiencyId = json['proficiencyId'];
    proficiencyName = json['proficiencyName'];
    read = json['dread'];
    write = json['dwrite'];
    speak = json['dspeak'];
    checkRead = json['read'];
    checkwrite = json['write'];
    checkspeak = json['speak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Language'] = this.languageId;
    data['languageName'] = this.languageName;
    data['Proficiency'] = this.proficiencyId;
    data['proficiencyName'] = this.proficiencyName;
    data['dread'] = this.read;
    data['dwrite'] = this.write;
    data['dspeak'] = this.speak;
    data['Read'] = this.checkRead;
    data['Write'] = this.checkwrite;
    data['Speak'] = this.checkspeak;
    return data;
  }


}
