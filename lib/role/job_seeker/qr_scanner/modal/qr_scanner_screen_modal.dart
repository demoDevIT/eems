class qr_scanner_screen_modal {
  int? state;
  bool? status;
  String? message;
  Null? errorMessage;
  Null? data;

  qr_scanner_screen_modal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  qr_scanner_screen_modal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    data['Data'] = this.data;
    return data;
  }
}