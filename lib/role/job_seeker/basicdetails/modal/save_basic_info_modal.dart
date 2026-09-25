class SaveBasicInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;

  SaveBasicInfoModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
  });

  SaveBasicInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['State'] = state;
    data['Status'] = status;
    data['Message'] = message;
    data['ErrorMessage'] = errorMessage;

    return data;
  }
}