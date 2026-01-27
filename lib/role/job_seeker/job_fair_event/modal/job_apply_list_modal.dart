class JobApplyListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  JobApplyListData? data;

  JobApplyListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  JobApplyListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new JobApplyListData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class JobApplyListData {
  List<JobApplyListDataTable>? table;
   

  JobApplyListData({this.table});

  JobApplyListData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <JobApplyListDataTable>[];
      json['Table'].forEach((v) {
        table!.add(new JobApplyListDataTable.fromJson(v));
      });
    }
     
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table!.map((v) => v.toJson()).toList();
    }
    
    return data;
  }
}

class JobApplyListDataTable {
  dynamic rowNum;
  dynamic nCOCode;
  dynamic nCOName;
  dynamic matchedJobPostCount;

  JobApplyListDataTable({this.rowNum, this.nCOCode, this.nCOName, this.matchedJobPostCount});

  JobApplyListDataTable.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    nCOCode = json['NCOCode'];
    nCOName = json['NCO_Name'];
    matchedJobPostCount = json['MatchedJobPostCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['NCOCode'] = this.nCOCode;
    data['NCO_Name'] = this.nCOName;
    data['MatchedJobPostCount'] = this.matchedJobPostCount;
    return data;
  }
}
