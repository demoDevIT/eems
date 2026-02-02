class DocumentMasterModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<DocumentMasterData>? data;

  DocumentMasterModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  DocumentMasterModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <DocumentMasterData>[];
      json['Data'].forEach((v) {
        data!.add(DocumentMasterData.fromJson(v));
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

class DocumentMasterData {
  int? schemeID;
  int? documentMasterId;
  String? documentMasterEn;
  String? documentMasterHi;
  String? shortName;
  int? isMandatory;
  String? fileName;

  DocumentMasterData({
    this.schemeID,
    this.documentMasterId,
    this.documentMasterEn,
    this.documentMasterHi,
    this.shortName,
    this.isMandatory,
    this.fileName,
  });

  factory DocumentMasterData.fromJson(Map<String, dynamic> json) {
    return DocumentMasterData(
      schemeID: json['SchemeID'],
      documentMasterId: json['DocumentMasterId'],
      documentMasterEn: json['DocumentMasterEn'],
      documentMasterHi: json['DocumentMasterHi'],
      shortName: json['ShortName'],
      isMandatory: json['IsMandatory'],
      fileName: json['FileName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['SchemeID'] = schemeID;
    json['DocumentMasterId'] = documentMasterId;
    json['DocumentMasterEn'] = documentMasterEn;
    json['DocumentMasterHi'] = documentMasterHi;
    json['ShortName'] = shortName;
    json['IsMandatory'] = isMandatory;
    json['FileName'] = fileName;
    return json;
  }

  /// ✅ IMPORTANT (for List / Map / comparison)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentMasterData &&
        other.documentMasterId == documentMasterId;
  }

  @override
  int get hashCode => documentMasterId.hashCode;
}

