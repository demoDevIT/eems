class SaveGrievanceModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;


  SaveGrievanceModal({this.state, this.status, this.message, this.errorMessage});

  SaveGrievanceModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;

    return data;
  }
}

