class ProfilePhysicalAttributeModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ProfilePhysicalAttributeData>? data;

  ProfilePhysicalAttributeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ProfilePhysicalAttributeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ProfilePhysicalAttributeData>[];
      json['Data'].forEach((v) {
        data!.add(new ProfilePhysicalAttributeData.fromJson(v));
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

class ProfilePhysicalAttributeData {
  dynamic physicalDetailID;
  dynamic isDisablity;
  dynamic disablityType;
  dynamic disabilityPercentage;
  dynamic disabilityName;
  dynamic heightInCMS;
  dynamic chestInCMS;
  dynamic weightInKG;
  dynamic eyeSight;
  dynamic bloodGroupID;
  dynamic bloodGroupName;

  ProfilePhysicalAttributeData(
      {this.physicalDetailID,
        this.isDisablity,
        this.disablityType,
        this.disabilityPercentage,
        this.disabilityName,
        this.heightInCMS,
        this.chestInCMS,
        this.weightInKG,
        this.eyeSight,
        this.bloodGroupID,
        this.bloodGroupName});

  ProfilePhysicalAttributeData.fromJson(Map<String, dynamic> json) {
    physicalDetailID = json['PhysicalDetailID'];
    isDisablity = json['IsDisablity'];
    disablityType = json['DisablityType'];
    disabilityPercentage = json['DisabilityPercentage'];
    disabilityName = json['DisabilityName'];
    heightInCMS = json['HeightInCMS'];
    chestInCMS = json['ChestInCMS'];
    weightInKG = json['WeightInKG'];
    eyeSight = json['EyeSight'];
    bloodGroupID = json['BloodGroupID'];
    bloodGroupName = json['BloodGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PhysicalDetailID'] = this.physicalDetailID;
    data['IsDisablity'] = this.isDisablity;
    data['DisablityType'] = this.disablityType;
    data['DisabilityPercentage'] = this.disabilityPercentage;
    data['DisabilityName'] = this.disabilityName;
    data['HeightInCMS'] = this.heightInCMS;
    data['ChestInCMS'] = this.chestInCMS;
    data['WeightInKG'] = this.weightInKG;
    data['EyeSight'] = this.eyeSight;
    data['BloodGroupID'] = this.bloodGroupID;
    data['BloodGroupName'] = this.bloodGroupName;
    return data;
  }
}
