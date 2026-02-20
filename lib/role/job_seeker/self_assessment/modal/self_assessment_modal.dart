class AssessmentListModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<AssessmentData>? data;

  AssessmentListModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  AssessmentListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <AssessmentData>[];
      json['Data'].forEach((v) {
        data!.add(AssessmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['State'] = state;
    json['Status'] = status;
    json['Message'] = message;
    json['ErrorMessage'] = errorMessage;
    if (data != null) {
      json['Data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class AssessmentData {
  int? id;
  String? name;
  int? durationMinutes;
  int? minQuestions;
  bool? isMandatory;
  int? assessmentTypeId;
  int? questions;

  AssessmentData({
    this.id,
    this.name,
    this.durationMinutes,
    this.minQuestions,
    this.isMandatory,
    this.assessmentTypeId,
    this.questions,
  });

  AssessmentData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    durationMinutes = json['DurationMinutes'];
    minQuestions = json['MinQuestions'];
    isMandatory = json['IsMandatory'];
    assessmentTypeId = json['AssessmentTypeId'];
    questions = json['questions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['Id'] = id;
    json['Name'] = name;
    json['DurationMinutes'] = durationMinutes;
    json['MinQuestions'] = minQuestions;
    json['IsMandatory'] = isMandatory;
    json['AssessmentTypeId'] = assessmentTypeId;
    json['questions'] = questions;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AssessmentData &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
