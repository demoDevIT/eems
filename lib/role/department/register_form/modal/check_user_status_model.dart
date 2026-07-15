class CheckUserStatusModel {
  final int? isApproved;
  final String? msg;

  CheckUserStatusModel({
    this.isApproved,
    this.msg,
  });

  factory CheckUserStatusModel.fromJson(Map<String, dynamic> json) {
    return CheckUserStatusModel(
      isApproved: json["IsApproved"],
      msg: json["MSG"],
    );
  }
}