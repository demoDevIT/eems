class UploadDocumentModal {
  int? state;
  String? message;
  dynamic errorMessage;
  List<UploadDocumentData>? data;

  UploadDocumentModal({this.state, this.message, this.errorMessage, this.data});

  UploadDocumentModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <UploadDocumentData>[];
      json['Data'].forEach((v) {
        data!.add(new UploadDocumentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UploadDocumentData {
  String? fileName;
  String? filePath;
  String? disFileName;
  String? folderName;

  UploadDocumentData(
      {this.fileName, this.filePath, this.disFileName, this.folderName});

  UploadDocumentData.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    filePath = json['FilePath'];
    disFileName = json['Dis_FileName'];
    folderName = json['FolderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    data['Dis_FileName'] = this.disFileName;
    data['FolderName'] = this.folderName;
    return data;
  }
}
