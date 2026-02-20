class AssessmentQuestion {
  int? id;
  String? question;
  List<String> options = [];
  List<int> optionIds = [];
  int? correct;

  AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    question = json['questions'];
    correct = json['Correct'];

    /// Handle opt (String OR List)
    if (json['opt'] is String) {
      options = (json['opt'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList();
    } else if (json['opt'] is List) {
      options = List<String>.from(json['opt']);
    }

    /// Handle optId (String OR List)
    if (json['optId'] is String) {
      optionIds = (json['optId'] as String)
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
    } else if (json['optId'] is List) {
      optionIds = List<int>.from(json['optId']);
    }
  }
}
