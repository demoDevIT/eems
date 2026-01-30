class StateModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<StateData>? data;

  StateModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  StateModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <StateData>[];
      json['Data'].forEach((v) {
        data!.add(StateData.fromJson(v));
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


class StateData {
  int? iD;
  String? name;
  String? code;
  dynamic unit;
  dynamic quantity;
  int? typeID;

  StateData({
    this.iD,
    this.name,
    this.code,
    this.unit,
    this.quantity,
    this.typeID,
  });

  StateData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    code = json['Code'];
    unit = json['Unit'];
    quantity = json['Quantity'];
    typeID = json['TypeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['ID'] = iD;
    json['Name'] = name;
    json['Code'] = code;
    json['Unit'] = unit;
    json['Quantity'] = quantity;
    json['TypeID'] = typeID;
    return json;
  }

  // ✅ REQUIRED FOR DROPDOWN
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StateData && other.iD == iD;

  // ✅ REQUIRED FOR DROPDOWN
  @override
  int get hashCode => iD.hashCode;
}




