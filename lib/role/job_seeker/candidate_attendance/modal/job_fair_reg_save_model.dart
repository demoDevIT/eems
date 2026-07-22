class JobFairRegistrationSaveModel {
  int? state;
  bool? status;
  String? message;
  List<JobFairRegistrationData>? data;

  JobFairRegistrationSaveModel({
    this.state,
    this.status,
    this.message,
    this.data,
  });

  factory JobFairRegistrationSaveModel.fromJson(
      Map<String, dynamic> json) {
    return JobFairRegistrationSaveModel(
      state: json['State'],
      status: json['Status'],
      message: json['Message'],
      data: (json['Data'] as List?)
          ?.map((e) => JobFairRegistrationData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class JobFairRegistrationData {
  double? eventRegistrationId;
  String? uniqueId;
  String? msg;

  JobFairRegistrationData.fromJson(
      Map<String, dynamic> json) {
    eventRegistrationId =
        (json['EventRegistrationId'] as num?)?.toDouble();

    uniqueId = json['UniqueId'];

    msg = json['MSG'];
  }
}