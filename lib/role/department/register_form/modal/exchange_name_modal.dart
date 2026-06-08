class ExchangeNameModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<ExchangeNameData>? data;

  ExchangeNameModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  ExchangeNameModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <ExchangeNameData>[];
      json['Data'].forEach((v) {
        data!.add(ExchangeNameData.fromJson(v));
      });
    }
  }
}

class ExchangeNameData {
  int? rowNo;
  int? officeId;
  String? officeName;
  // int? stateId;
  // String? stateName;
  // int? districtId;
  // String? districtName;
  // int? isActive;
  // String? districtCode;
  // String? createdOn;

  ExchangeNameData({
    this.rowNo,
    this.officeId,
    this.officeName,
    // this.stateId,
    // this.stateName,
    // this.districtId,
    // this.districtName,
    // this.isActive,
    // this.districtCode,
    // this.createdOn,
  });

  factory ExchangeNameData.fromJson(Map<String, dynamic> json) {
    return ExchangeNameData(
      rowNo: json['RowNo'],
      officeId: json['OfficeId'],
      officeName: json['OfficeName'],
      // stateId: json['StateId'],
      // stateName: json['StateName'],
      // districtId: json['DistrictId'],
      // districtName: json['DistrictName'],
      // isActive: json['IsActive'],
      // districtCode: json['DistrictCode'],
      // createdOn: json['CreatedOn'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExchangeNameData && other.officeId == officeId;
  }

  @override
  int get hashCode => officeId.hashCode;
}