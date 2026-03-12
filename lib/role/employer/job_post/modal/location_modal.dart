class LocationModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<LocationData>? data;

  LocationModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  LocationModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <LocationData>[];
      json['Data'].forEach((v) {
        data!.add(new LocationData.fromJson(v));
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

class LocationData {
  String? dropID;
  String? name;
  int? cityId;

  LocationData({this.dropID, this.name, this.cityId});

  LocationData.fromJson(Map<String, dynamic> json) {
    dropID = json['CommonID'];
    name = json['Name'];
    cityId = json['City_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommonID'] = this.dropID;
    data['Name'] = this.name;
    data['City_Id'] = this.cityId;
    return data;
  }
}
