class GenerateOTPModal {
  int? state;
  bool? status;
  dynamic message;
  String? errorMessage;
  GenerateOTPData? data;

  GenerateOTPModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  GenerateOTPModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new GenerateOTPData.fromJson(json['Data']) : null;
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

class GenerateOTPData {
  GenerateOTPDataResponse? response;
  String? signature;

  GenerateOTPData({this.response, this.signature});

  GenerateOTPData.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new GenerateOTPDataResponse.fromJson(json['response'])
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

class GenerateOTPDataResponse {
  bool? status;
  String? message;
  String? responseCode;
  String? transactionId;
  String? schemeCode;
  String? appCode;
  String? tid;
  dynamic data;
  dynamic janId;

  GenerateOTPDataResponse(
      {this.status,
        this.message,
        this.responseCode,
        this.transactionId,
        this.schemeCode,
        this.appCode,
        this.tid,
        this.data,
        this.janId});

  GenerateOTPDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    transactionId = json['transactionId'];
    schemeCode = json['schemeCode'];
    appCode = json['appCode'];
    tid = json['tid'];
    data = json['data'];
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
    data['data'] = this.data;
    data['janId'] = this.janId;
    return data;
  }
}
