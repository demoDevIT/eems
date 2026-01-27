class CompanyListModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CompanyListData>? data;

  CompanyListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CompanyListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CompanyListData>[];
      json['Data'].forEach((v) {
        data!.add(new CompanyListData.fromJson(v));
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

class CompanyListData {
  String? comapnyname;
  int? totalVacany;
  String? headLocality;

  CompanyListData({this.comapnyname, this.totalVacany, this.headLocality});

  CompanyListData.fromJson(Map<String, dynamic> json) {
    comapnyname = json['comapnyname'];
    totalVacany = json['totalVacany'];
    headLocality = json['Head_Locality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comapnyname'] = this.comapnyname;
    data['totalVacany'] = this.totalVacany;
    data['Head_Locality'] = this.headLocality;
    return data;
  }
}
