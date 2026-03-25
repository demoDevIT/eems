class YearModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<YearData>? data;

  // YearModal(
  //     {this.state, this.status, this.message, this.errorMessage, this.data});

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

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['State'] = this.state;
  //   data['Status'] = this.status;
  //   data['Message'] = this.message;
  //   data['ErrorMessage'] = this.errorMessage;
  //   if (this.data != null) {
  //     data['Data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class YearData {
  int? dropID;
  String? name;

 // YearData({this.dropID, this.name});

  YearData.fromJson(Map<String, dynamic> json) {
    dropID = json['ID'];
    name = json['Year']?.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is YearData &&
              other.dropID == dropID;

  @override
  int get hashCode => dropID.hashCode;

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['ID'] = this.dropID;
  //   data['Year'] = this.name;
  //   return data;
  // }
}
