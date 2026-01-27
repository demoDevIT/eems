class DownloadRegistractionModal {
  int? userId;
  String? pdfBase64;

  DownloadRegistractionModal({this.userId, this.pdfBase64});

  DownloadRegistractionModal.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    pdfBase64 = json['PdfBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['PdfBase64'] = this.pdfBase64;
    return data;
  }
}
