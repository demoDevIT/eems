class GrievanceTrailModel {
  int? state;
  String? message;
  List<GrievanceTrailData>? data;

  GrievanceTrailModel({this.state, this.message, this.data});

  GrievanceTrailModel.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    message = json['Message'];

    if (json['Data'] != null) {
      data = <GrievanceTrailData>[];
      json['Data'].forEach((v) {
        data!.add(GrievanceTrailData.fromJson(v));
      });
    }
  }
}

class GrievanceTrailData {
  int? grievanceID;
  String? complainNo;
  String? subject;
  int? categoryID;
  int? categoryType;
  String? moduleNameEn;
  int? createdBy;
  String? rts;
  String? remark;
  int? statusID;
  String? fileAttachment;
  String? disAttachmentFileName;

  GrievanceTrailData.fromJson(Map<String, dynamic> json) {
    grievanceID = json['GrievanceID'];
    complainNo = json['ComplainNo'];
    subject = json['Subject'];
    categoryID = json['CategoryID'];
    categoryType = json['CategoryType'];
    moduleNameEn = json['ModuleNameEn'];
    createdBy = json['CreatedBy'];
    rts = json['RTS'];
    remark = json['Remark'];
    statusID = json['StatusID'];
    fileAttachment = json['FileAttachment'];
    disAttachmentFileName = json['DisAttachmentFileName'];
  }
}

