class ColorCodeModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<ColorCodeData>? data;

  ColorCodeModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  ColorCodeModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <ColorCodeData>[];
      json['Data'].forEach((v) {
        data!.add(new ColorCodeData.fromJson(v));
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

class ColorCodeData {
  dynamic colourCodeId;
  dynamic colourCode;

  ColorCodeData({this.colourCodeId, this.colourCode});

  ColorCodeData.fromJson(Map<String, dynamic> json) {
    colourCodeId = json['ColourCodeId'];
    colourCode = json['ColourCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ColourCodeId'] = this.colourCodeId;
    data['ColourCode'] = this.colourCode;
    return data;
  }
}
