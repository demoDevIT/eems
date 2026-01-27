class AllCVTemplateListModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  List<AllCVTemplateListData>? data;

  AllCVTemplateListModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  AllCVTemplateListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <AllCVTemplateListData>[];
      json['Data'].forEach((v) {
        data!.add(new AllCVTemplateListData.fromJson(v));
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

class AllCVTemplateListData {
  dynamic templateId;
  dynamic headshotType;
  dynamic columnsType;
  dynamic clourId;
  dynamic colourCode;
  dynamic tradeId;
  dynamic templateHtml;
  dynamic templateCSS;
  dynamic isActive;
  dynamic createdDate;
  dynamic createdBy;
  dynamic createdByIP;
  dynamic updatedBy;
  dynamic updatedDate;
  dynamic updatedByIP;

  AllCVTemplateListData(
      {this.templateId,
        this.headshotType,
        this.columnsType,
        this.clourId,
        this.colourCode,
        this.tradeId,
        this.templateHtml,
        this.templateCSS,
        this.isActive,
        this.createdDate,
        this.createdBy,
        this.createdByIP,
        this.updatedBy,
        this.updatedDate,
        this.updatedByIP});

  AllCVTemplateListData.fromJson(Map<String, dynamic> json) {
    templateId = json['TemplateId'];
    headshotType = json['HeadshotType'];
    columnsType = json['ColumnsType'];
    clourId = json['ClourId'];
    colourCode = json['ColourCode'];
    tradeId = json['TradeId'];
    templateHtml = json['TemplateHtml'];
    templateCSS = json['TemplateCSS'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    createdBy = json['CreatedBy'];
    createdByIP = json['CreatedBy_IP'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    updatedByIP = json['UpdatedBy_IP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TemplateId'] = this.templateId;
    data['HeadshotType'] = this.headshotType;
    data['ColumnsType'] = this.columnsType;
    data['ClourId'] = this.clourId;
    data['ColourCode'] = this.colourCode;
    data['TradeId'] = this.tradeId;
    data['TemplateHtml'] = this.templateHtml;
    data['TemplateCSS'] = this.templateCSS;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;
    data['CreatedBy_IP'] = this.createdByIP;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['UpdatedBy_IP'] = this.updatedByIP;
    return data;
  }
}
