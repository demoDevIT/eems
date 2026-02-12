class LevelModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<LevelData>? data;

  LevelModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data!.add(LevelData.fromJson(v));
      });
    }
  }
}

class LevelData {
  int? levelID;
  String? levelNameEnglish;
  String? levelNameHindi;

  LevelData.fromJson(Map<String, dynamic> json) {
    levelID = json['LevelID'];
    levelNameEnglish = json['LevelNameEnglish'];
    levelNameHindi = json['LevelNameHindi'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LevelData && other.levelID == levelID;

  @override
  int get hashCode => levelID.hashCode;
}
