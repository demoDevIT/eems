class FetchMemberListModal {
  int? state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  FetchMemberListData? data;

  FetchMemberListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  FetchMemberListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new FetchMemberListData.fromJson(json['Data']) : null;
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

class FetchMemberListData {
  FetchMemberResponse? response;
  String? signature;

  FetchMemberListData({this.response, this.signature});

  FetchMemberListData.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new FetchMemberResponse.fromJson(json['response'])
        : null;
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['signature'] = this.signature;
    return data;
  }
}

class FetchMemberResponse {
  bool? status;
  String? message;
  String? responseCode;
  String? transactionId;
  String? schemeCode;
  String? appCode;
  dynamic tid;
  List<FetchMemberDataResponse>? data;
  String? janId;

  FetchMemberResponse(
      {this.status,
        this.message,
        this.responseCode,
        this.transactionId,
        this.schemeCode,
        this.appCode,
        this.tid,
        this.data,
        this.janId});

  FetchMemberResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    transactionId = json['transactionId'];
    schemeCode = json['schemeCode'];
    appCode = json['appCode'];
    tid = json['tid'];
    if (json['data'] != null) {
      data = <FetchMemberDataResponse>[];
      json['data'].forEach((v) {
        data!.add(new FetchMemberDataResponse.fromJson(v));
      });
    }
    janId = json['janId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    data['transactionId'] = this.transactionId;
    data['schemeCode'] = this.schemeCode;
    data['appCode'] = this.appCode;
    data['tid'] = this.tid;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['janId'] = this.janId;
    return data;
  }
}

class FetchMemberDataResponse {
  int? mEMBERID;
  String? nAMEEN;
  String? mEMBERTYPE;

  FetchMemberDataResponse({this.mEMBERID, this.nAMEEN, this.mEMBERTYPE});

  FetchMemberDataResponse.fromJson(Map<String, dynamic> json) {
    mEMBERID = json['MEMBER_ID'];
    nAMEEN = json['NAME_EN'];
    mEMBERTYPE = json['MEMBER_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MEMBER_ID'] = this.mEMBERID;
    data['NAME_EN'] = this.nAMEEN;
    data['MEMBER_TYPE'] = this.mEMBERTYPE;
    return data;
  }
}
