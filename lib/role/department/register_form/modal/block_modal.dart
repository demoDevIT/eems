class BlockModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<BlockData>? data;

  BlockModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  BlockModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <BlockData>[];
      json['Data'].forEach((v) {
        data!.add(BlockData.fromJson(v));
      });
    }
  }
}

class BlockData {
  int? iD;
  String? code;
  String? nameEng;
  String? nameMangal;

  BlockData({
    this.iD,
    this.code,
    this.nameEng,
    this.nameMangal,
  });

  factory BlockData.fromJson(Map<String, dynamic> json) {
    return BlockData(
      iD: json['ID'],
      code: json['CODE'],
      nameEng: json['Name_ENG'],
      nameMangal: json['Name_MANGAL'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlockData && other.iD == iD;
  }

  @override
  int get hashCode => iD.hashCode;
}
