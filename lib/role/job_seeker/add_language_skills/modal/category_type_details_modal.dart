class GetCategoryTypeDetailsModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<GetCategoryTypeDetailsData>? data;

  GetCategoryTypeDetailsModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GetCategoryTypeDetailsModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GetCategoryTypeDetailsData>[];
      json['Data'].forEach((v) {
        data!.add(new GetCategoryTypeDetailsData.fromJson(v));
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

class GetCategoryTypeDetailsData {
  dynamic dropID;
  dynamic name;
  dynamic nameHIN;

  GetCategoryTypeDetailsData({this.dropID, this.name, this.nameHIN});

  GetCategoryTypeDetailsData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name_ENG'];
    nameHIN = json['Name_HIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.dropID;
    data['Name_ENG'] = this.name;
    data['Name_HIN'] = this.nameHIN;
    return data;
  }
}
