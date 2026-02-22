class CorrectSaveAnswersModal {
  int? state;
  String? message;
  dynamic data;

  CorrectSaveAnswersModal({
    this.state,
    this.message,
    this.data,
  });

  factory CorrectSaveAnswersModal.fromJson(
      Map<String, dynamic> json) {
    return CorrectSaveAnswersModal(
      state: json['state'],
      message: json['message'],
      data: json['data'],
    );
  }
}