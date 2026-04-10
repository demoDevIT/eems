class AboutAppModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<AboutAppModalData>? data;

  AboutAppModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  AboutAppModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <AboutAppModalData>[];
      json['Data'].forEach((v) {
        data!.add(new AboutAppModalData.fromJson(v));
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

class AboutAppModalData {
  dynamic dynamicUploadContentID;
  dynamic dynamicTypeID;
  dynamic titleEng;
  dynamic titleHI;
  dynamic htmlEng;
  dynamic htmlHI;
  dynamic contentFileEng;
  dynamic contentFileHI;
  dynamic isContentType;
  dynamic externalURL;
  dynamic createdBy;
  dynamic ducCreatedDate;
  dynamic createdByIP;
  dynamic isApproved;
  dynamic approvedBy;
  dynamic ducApprovedDate;
  dynamic approvedByIP;
  dynamic isPublished;
  dynamic publishBy;
  dynamic ducPublishDate;
  dynamic publishByIP;
  dynamic updatedBy;
  dynamic ducUpdatedDate;
  dynamic updatedByIP;
  dynamic ducStartDate;
  dynamic startDate;
  dynamic isLimitedTime;
  dynamic ducEndDate;
  dynamic endDate;
  dynamic startTme;
  dynamic endTime;
  dynamic isNew;
  dynamic isActive;
  dynamic isDelete;
  dynamic dtNameEng;
  dynamic dtNameHi;

  AboutAppModalData(
      {this.dynamicUploadContentID,
        this.dynamicTypeID,
        this.titleEng,
        this.titleHI,
        this.htmlEng,
        this.htmlHI,
        this.contentFileEng,
        this.contentFileHI,
        this.isContentType,
        this.externalURL,
        this.createdBy,
        this.ducCreatedDate,
        this.createdByIP,
        this.isApproved,
        this.approvedBy,
        this.ducApprovedDate,
        this.approvedByIP,
        this.isPublished,
        this.publishBy,
        this.ducPublishDate,
        this.publishByIP,
        this.updatedBy,
        this.ducUpdatedDate,
        this.updatedByIP,
        this.ducStartDate,
        this.startDate,
        this.isLimitedTime,
        this.ducEndDate,
        this.endDate,
        this.startTme,
        this.endTime,
        this.isNew,
        this.isActive,
        this.isDelete,
        this.dtNameEng,
        this.dtNameHi
      });

  AboutAppModalData.fromJson(Map<String, dynamic> json) {
    dynamicUploadContentID = json['DynamicUploadContentID'];
    dynamicTypeID = json['DynamicTypeID'];
    titleEng = json['DUC_Title_Eng'];
    titleHI = json['DUC_Title_Hi'];
    htmlEng = json['HTMLContent_Eng'];
    htmlHI = json['HTMLContent_Hi'];
    contentFileEng = json['ContentFileEng'];
    contentFileHI = json['ContentFileHi'];
    isContentType = json['IsContentType'];
    externalURL = json['ExternalURL'];
    createdBy = json['CreatedBy'];
    ducCreatedDate = json['DUCCreatedDate'];
    createdByIP = json['CreatedBy_IP'];
    isApproved = json['IsApproved'];
    approvedBy = json['ApprovedBy'];
    ducApprovedDate = json['DUCApprovedDate'];
    approvedByIP = json['ApprovedBy_IP'];
    isPublished = json['IsPublished'];
    publishBy = json['PublishBy'];
    ducPublishDate = json['DUCPublishDate'];
    publishByIP = json['PublishBy_IP'];
    updatedBy = json['UpdatedBy'];
    ducUpdatedDate = json['DUCUpdatedDate'];
    updatedByIP = json['UpdatedBy_IP'];
    ducStartDate = json['DUCStartDate'];
    startDate = json['StartDate'];
    isLimitedTime = json['IsLimitedTime'];
    ducEndDate = json['DUCEndDate'];
    endDate = json['EndDate'];
    startTme = json['StartTme'];
    endTime = json['EndTime'];
    isNew = json['IsNew'];
    isActive = json['IsActive'];
    isDelete = json['IsDelete'];
    dtNameEng = json['DTName_Eng'];
    dtNameHi = json['DTName_Hi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DynamicUploadContentID'] = this.dynamicUploadContentID;
    data['DynamicTypeID'] = this.dynamicTypeID;
    data['DUC_Title_Eng'] = this.titleEng;
    data['DUC_Title_Hi'] = this.titleHI;
    data['HTMLContent_Eng'] = this.htmlEng;
    data['HTMLContent_Hi'] = this.htmlHI;
    data['ContentFileEng'] = this.contentFileEng;
    data['ContentFileHi'] = this.contentFileHI;
    data['IsContentType'] = this.isContentType;
    data['ExternalURL'] = this.externalURL;
    data['CreatedBy'] = this.createdBy;
    data['DUCCreatedDate'] = this.ducCreatedDate;
    data['CreatedBy_IP'] = this.createdByIP;
    data['IsApproved'] = this.isApproved;
    data['ApprovedBy'] = this.approvedBy;
    data['DUCApprovedDate'] = this.ducApprovedDate;
    data['ApprovedBy_IP'] = this.approvedByIP;
    data['IsPublished'] = this.isPublished;
    data['PublishBy'] = this.publishBy;
    data['DUCPublishDate'] = this.ducPublishDate;
    data['PublishBy_IP'] = this.publishByIP;
    data['UpdatedBy'] = this.updatedBy;
    data['DUCUpdatedDate'] = this.ducUpdatedDate;
    data['UpdatedBy_IP'] = this.updatedByIP;
    data['DUCStartDate'] = this.ducStartDate;
    data['StartDate'] = this.startDate;
    data['IsLimitedTime'] = this.isLimitedTime;
    data['DUCEndDate'] = this.ducEndDate;
    data['EndDate'] = this.endDate;
    data['StartTme'] = this.startTme;
    data['EndTime'] = this.endTime;
    data['IsNew'] = this.isNew;
    data['IsActive'] = this.isActive;
    data['IsDelete'] = this.isDelete;
    data['DTName_Eng'] = this.dtNameEng;
    data['DTName_Hi'] = this.dtNameHi;

    return data;
  }
}
