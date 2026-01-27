class BoardModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<BoardData>? data;

  BoardModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  BoardModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <BoardData>[];
      json['Data'].forEach((v) {
        data!.add(new BoardData.fromJson(v));
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

class BoardData {
  int? dropID;
  String? name;
  String? boardMANGAL;

  BoardData({this.dropID, this.name, this.boardMANGAL});

  BoardData.fromJson(Map<String, dynamic> json) {
    dropID = json['BoardID'];
    name = json['Board_ENG'];
    boardMANGAL = json['Board_MANGAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BoardID'] = this.dropID;
    data['Board_ENG'] = this.name;
    data['Board_MANGAL'] = this.boardMANGAL;
    return data;
  }
}
