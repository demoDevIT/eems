class FinancialYearModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<FinancialYearData>? data;

  FinancialYearModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  FinancialYearModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <FinancialYearData>[];
      json['Data'].forEach((v) {
        data!.add(FinancialYearData.fromJson(v));
      });
    }
  }
}

class FinancialYearData {
  int? financialYearID;
  String? financialYearName;
  String? yearName;
  int? isCurrentFY;

  FinancialYearData({
    this.financialYearID,
    this.financialYearName,
    this.yearName,
    this.isCurrentFY,
  });

  FinancialYearData.fromJson(Map<String, dynamic> json) {
    financialYearID = json['FinancialYearID'];
    financialYearName = json['FinancialYearName'];
    yearName = json['YearName'];
    isCurrentFY = json['IsCurrentFY'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FinancialYearData &&
              other.financialYearID == financialYearID;

  @override
  int get hashCode => financialYearID.hashCode;
}
