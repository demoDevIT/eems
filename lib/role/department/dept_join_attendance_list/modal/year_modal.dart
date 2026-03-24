class YearModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<YearData>? data;

  YearModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <YearData>[];
      json['Data'].forEach((v) {
        data!.add(YearData.fromJson(v));
      });
    }
  }
}

class YearData {
  int? dropID;
  String? name;

  YearData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Year'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is YearData &&
              other.dropID == dropID;

  @override
  int get hashCode => dropID.hashCode;
}
