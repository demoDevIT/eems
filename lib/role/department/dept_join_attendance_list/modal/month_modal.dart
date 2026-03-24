class MonthModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<MonthData>? data;

  // MonthModal({
  //   this.state,
  //   this.status,
  //   this.message,
  //   this.errorMessage,
  //   this.data,
  // });

  MonthModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <MonthData>[];
      json['Data'].forEach((v) {
        data!.add(MonthData.fromJson(v));
      });
    }
  }
}

class MonthData {
  int? dropID;
  String? name;

  // MonthData({
  //   this.dropID,
  //   this.name,
  // });

  MonthData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Name'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MonthData &&
              other.dropID == dropID;

  @override
  int get hashCode => dropID.hashCode;
}
