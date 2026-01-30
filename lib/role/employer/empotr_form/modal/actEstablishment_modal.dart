class ActEstablishmentModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<ActEstablishmentData>? data;

  ActEstablishmentModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  ActEstablishmentModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <ActEstablishmentData>[];
      json['Data'].forEach((v) {
        data!.add(ActEstablishmentData.fromJson(v));
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
class ActEstablishmentData {
  int? rangeId;
  int? minEmployees;
  int? maxEmployees;
  String? actEstablishment;

  ActEstablishmentData({
    this.rangeId,
    this.minEmployees,
    this.maxEmployees,
    this.actEstablishment,
  });

  ActEstablishmentData.fromJson(Map<String, dynamic> json) {
    rangeId = json['Range_ID'];
    minEmployees = json['MinEmployees'];
    maxEmployees = json['MaxEmployees'];
    actEstablishment = json['ActEstablishment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['Range_ID'] = rangeId;
    json['MinEmployees'] = minEmployees;
    json['MaxEmployees'] = maxEmployees;
    json['ActEstablishment'] = actEstablishment;
    return json;
  }

  // ✅ REQUIRED FOR DROPDOWN SELECTION
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ActEstablishmentData &&
              other.actEstablishment == actEstablishment;

  // ✅ REQUIRED FOR DROPDOWN SELECTION
  @override
  int get hashCode => actEstablishment.hashCode;
}
