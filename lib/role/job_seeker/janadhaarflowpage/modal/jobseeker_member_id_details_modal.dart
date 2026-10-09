class JobseekerMemberIdDetailsModal {
  int? state;
  bool? status;
  String? message;
  String? errorMessage;
  List<JobseekerMemberIdDetails>? data;

  JobseekerMemberIdDetailsModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  JobseekerMemberIdDetailsModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <JobseekerMemberIdDetails>[];

      json['Data'].forEach((v) {
        data!.add(JobseekerMemberIdDetails.fromJson(v));
      });
    }
  }
}

class JobseekerMemberIdDetails {
  String? memberId;
  int? flag;
  String? message;

  JobseekerMemberIdDetails({
    this.memberId,
    this.flag,
    this.message,
  });

  JobseekerMemberIdDetails.fromJson(Map<String, dynamic> json) {
    memberId = json['MEMBER_ID']?.toString();
    flag = json['flag'];
    message = json['Message'];
  }
}