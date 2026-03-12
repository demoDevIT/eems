class NcoCodeModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<NcoCodeData>? data;

  NcoCodeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  NcoCodeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <NcoCodeData>[];
      json['Data'].forEach((v) {
        data!.add(new NcoCodeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NcoCodeData {
  String? name;
  String? dropID;

  NcoCodeData({this.name, this.dropID});

  NcoCodeData.fromJson(Map<String, dynamic> json) {
    name = json['NCOName'];
    dropID = json['NCOCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NCOName'] = this.name;
    data['NCOCode'] = this.dropID;
    return data;
  }
}
