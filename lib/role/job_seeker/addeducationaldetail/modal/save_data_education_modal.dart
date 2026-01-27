class SaveDataEducationModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<SaveDataEducationModal>? data;

  SaveDataEducationModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  SaveDataEducationModal.fromJson(Map<String, dynamic> json) {
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
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

