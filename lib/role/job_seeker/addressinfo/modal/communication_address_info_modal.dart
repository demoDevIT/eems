class CommunicationAddressInfoModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<CommunicationAddressInfoData>? data;

  CommunicationAddressInfoModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  CommunicationAddressInfoModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    if (json['Data'] != null) {
      data = <CommunicationAddressInfoData>[];
      json['Data'].forEach((v) {
        data!.add(new CommunicationAddressInfoData.fromJson(v));
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

class CommunicationAddressInfoData {
  String? dISTRICTCODE;
  String? dISTRICTENG;
  dynamic bLOCKID;
  dynamic bLOCKENG;
  String? cITYCODE;
  String? cITYENG;
  String? wARDCODE;
  String? wARDENG;
  dynamic gPCODE;
  dynamic gPENG;
  dynamic vILLAGECODE;
  dynamic vILLAGEENG;
  int? pincode;
  int? territoryType;
  String? address;
  String? parliamentCode;
  String? assemblyCode;
  int? sameASPermanent;
  String? aCENG;
  String? pCENG;

  CommunicationAddressInfoData(
      {this.dISTRICTCODE,
        this.dISTRICTENG,
        this.bLOCKID,
        this.bLOCKENG,
        this.cITYCODE,
        this.cITYENG,
        this.wARDCODE,
        this.wARDENG,
        this.gPCODE,
        this.gPENG,
        this.vILLAGECODE,
        this.vILLAGEENG,
        this.pincode,
        this.territoryType,
        this.address,
        this.parliamentCode,
        this.assemblyCode,
        this.sameASPermanent,
        this.aCENG,
        this.pCENG,});

  CommunicationAddressInfoData.fromJson(Map<String, dynamic> json) {
    dISTRICTCODE = json['DISTRICT_CODE'];
    dISTRICTENG = json['DISTRICT_ENG'];
    bLOCKID = json['BLOCK_ID'];
    bLOCKENG = json['BLOCK_ENG'];
    cITYCODE = json['CITY_CODE'];
    cITYENG = json['CITY_ENG'];
    wARDCODE = json['WARD_CODE'];
    wARDENG = json['WARD_ENG'];
    gPCODE = json['GP_CODE'];
    gPENG = json['GP_ENG'];
    vILLAGECODE = json['VILLAGE_CODE'];
    vILLAGEENG = json['VILLAGE_ENG'];
    pincode = json['Pincode'];
    territoryType = json['TerritoryType'];
    address = json['Address'];
    parliamentCode = json['ParliamentCode'];
    assemblyCode = json['AssemblyCode'];
    sameASPermanent = json['SameASPermanent'];
    aCENG = json['AC_ENG'];
    pCENG = json['PC_ENG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DISTRICT_CODE'] = this.dISTRICTCODE;
    data['DISTRICT_ENG'] = this.dISTRICTENG;
    data['BLOCK_ID'] = this.bLOCKID;
    data['BLOCK_ENG'] = this.bLOCKENG;
    data['CITY_CODE'] = this.cITYCODE;
    data['CITY_ENG'] = this.cITYENG;
    data['WARD_CODE'] = this.wARDCODE;
    data['WARD_ENG'] = this.wARDENG;
    data['GP_CODE'] = this.gPCODE;
    data['GP_ENG'] = this.gPENG;
    data['VILLAGE_CODE'] = this.vILLAGECODE;
    data['VILLAGE_ENG'] = this.vILLAGEENG;
    data['Pincode'] = this.pincode;
    data['TerritoryType'] = this.territoryType;
    data['Address'] = this.address;
    data['ParliamentCode'] = this.parliamentCode;
    data['AssemblyCode'] = this.assemblyCode;
    data['SameASPermanent'] = this.sameASPermanent;
    data['AC_ENG'] = this.aCENG;
    data['PC_ENG'] = this.pCENG;
    return data;
  }
}
