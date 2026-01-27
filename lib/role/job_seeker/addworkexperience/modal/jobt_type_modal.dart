class JobtTypeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<JobtTypeData>? data;

  JobtTypeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobtTypeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <JobtTypeData>[];
      json['Data'].forEach((v) {
        data!.add(new JobtTypeData.fromJson(v));
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

class JobtTypeData {
  int? dropID;
  String? name;

  JobtTypeData({this.dropID, this.name});

  JobtTypeData.fromJson(Map<String, dynamic> json) {
    dropID = json['CommonID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommonID'] = this.dropID;
    data['Name'] = this.name;
    return data;
  }
}
