class GetCourseModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<GetCourseData>? data;

  GetCourseModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GetCourseModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <GetCourseData>[];
      json['Data'].forEach((v) {
        data!.add(new GetCourseData.fromJson(v));
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

class GetCourseData {
  dynamic dropID;
  dynamic name;

  GetCourseData({this.dropID, this.name});

  GetCourseData.fromJson(Map<String, dynamic> json) {
    dropID = json['QualificationID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QualificationID'] = this.dropID;
    data['Name'] = this.name;
    return data;
  }
}
