class FaqsAssistanceModel {
  dynamic state;
  bool? status;
  dynamic message;
  dynamic errorMessage;
  List<FaqsAssistanceData>? dataFaqs;

  FaqsAssistanceModel(
      {this.state, this.status, this.message, this.errorMessage, this.dataFaqs});

  FaqsAssistanceModel.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      dataFaqs = <FaqsAssistanceData>[];
      json['Data'].forEach((v) {
        dataFaqs!.add(new FaqsAssistanceData.fromJson(v));
      });
    }
  }
}

class FaqsAssistanceData {
  String? fAQAssistanceId;
  String? parentID;
  String? faqAssistanceHi;
  String? faqAssistanceEng;
  String? enumName;

  FaqsAssistanceData({this.fAQAssistanceId,this.parentID, this.faqAssistanceHi, this.faqAssistanceEng, this.enumName});

  FaqsAssistanceData.fromJson(Map<String, dynamic> json) {
    fAQAssistanceId = json['FAQAssistanceId'].toString();
    parentID = json['ParentID'].toString();
    faqAssistanceHi = json['FAQAssistance_HI'];
    faqAssistanceEng = json['FAQAssistance_ENG'];
    enumName = json['EnumName'];
  }
}