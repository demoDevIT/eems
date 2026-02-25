class MysyListModel {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<MysyData>? data;

  MysyListModel({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  MysyListModel.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <MysyData>[];
      json['Data'].forEach((v) {
        data!.add(MysyData.fromJson(v));
      });
    }
  }
}

class MysyData {
  int? applicationId;
  String? applicationNo;
  String? fullName;
  String? fatherName;
  String? aadharNo;
  String? gender;
  String? category;
  String? dob;
  String? schemeName;
  String? schemeStatus;
  String? createdOn;

  MysyData({
    this.applicationId,
    this.applicationNo,
    this.fullName,
    this.fatherName,
    this.aadharNo,
    this.gender,
    this.category,
    this.dob,
    this.schemeName,
    this.schemeStatus,
    this.createdOn,
  });

  factory MysyData.fromJson(Map<String, dynamic> json) {
    return MysyData(
      applicationId: json['ApplicationId'],
      applicationNo: json['ApplicationNo'] ?? "",
      fullName: json['FullName'] ?? "",
      fatherName: json['FatherName'] ?? "",
      aadharNo: json['AadharNo'] ?? "",
      gender: json['Gender'] ?? "",
      category: json['Category'] ?? "",
      dob: json['DOB'] ?? "",
      schemeName: json['SchemeName'] ?? "",
      schemeStatus: json['SchemeStatus'] ?? "",
      createdOn: json['CreatedOn'] ?? "",
    );
  }
}