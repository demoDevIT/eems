class DeptInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DeptInfoData>? data;

  DeptInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  DeptInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <DeptInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new DeptInfoData.fromJson(v));
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

class DeptInfoData {
  dynamic userID;
  dynamic name;
  dynamic mobileNo;
  dynamic userType;
  dynamic office;
  dynamic designation;
  dynamic role;
  dynamic territoryType;
  dynamic village;
  dynamic gp;
  dynamic block;
  dynamic ward;
  dynamic city;
  dynamic district;

  DeptInfoData(
      {this.userID,
        this.name,
        this.mobileNo,
        this.userType,
        this.office,
        this.designation,
        this.role,
        this.territoryType,
        this.village,
        this.gp,
        this.block,
        this.ward,
        this.city,
        this.district,
      });

  DeptInfoData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    userType = json['UserType'];
    office = json['Office'];
    designation = json['Designation'];
    role = json['Role'];
    territoryType = json['TerritoryType'];
    village = json['Village'];
    gp = json['GP'];
    block = json['Block'];
    ward = json['Ward'];
    city = json['City'];
    district = json['District'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['Name'] = this.name;
    data['MobileNo'] = this.mobileNo;
    data['UserType'] = this.userType;
    data['Office'] = this.office;
    data['Designation'] = this.designation;
    data['Role'] = this.role;
    data['TerritoryType'] = this.territoryType;
    data['Village'] = this.village;
    data['GP'] = this.gp;
    data['Block'] = this.block;
    data['Ward'] = this.ward;
    data['City'] = this.city;
    data['District'] = this.district;
    return data;
  }
}
