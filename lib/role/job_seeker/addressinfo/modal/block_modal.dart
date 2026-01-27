class BlockModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<BlockData>? data;

  BlockModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  BlockModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <BlockData>[];
      json['Data'].forEach((v) {
        data!.add(new BlockData.fromJson(v));
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

class BlockData {
  int? dISTRICTID;
  String? dISTRICTENG;
  int? dIVISIONID;
  String? status;
  int? dISTRICTCODE;

  BlockData(
      {this.dISTRICTID,
        this.dISTRICTENG,
        this.dIVISIONID,
        this.status,
        this.dISTRICTCODE});

  BlockData.fromJson(Map<String, dynamic> json) {
    dISTRICTID = json['DISTRICT_ID'];
    dISTRICTENG = json['DISTRICT_ENG'];
    dIVISIONID = json['DIVISION_ID'];
    status = json['Status'];
    dISTRICTCODE = json['DISTRICT_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DISTRICT_ID'] = this.dISTRICTID;
    data['DISTRICT_ENG'] = this.dISTRICTENG;
    data['DIVISION_ID'] = this.dIVISIONID;
    data['Status'] = this.status;
    data['DISTRICT_CODE'] = this.dISTRICTCODE;
    return data;
  }
}
