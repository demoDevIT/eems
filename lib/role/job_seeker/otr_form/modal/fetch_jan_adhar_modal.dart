class FetchJanAdharModal {
  dynamic state;
  dynamic status;
  dynamic message;
  dynamic errorMessage;
  FetchJanAdharData? data;

  FetchJanAdharModal(
      {this.state, this.status, this.message, this.errorMessage, this.data});

  FetchJanAdharModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'] != null ? new FetchJanAdharData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ErrorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class FetchJanAdharData {
  FetchJanAdharResponse? response;
  dynamic signature;

  FetchJanAdharData({this.response, this.signature});

  FetchJanAdharData.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new FetchJanAdharResponse.fromJson(json['response'])
        : null;
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['signature'] = this.signature;
    return data;
  }
}

class FetchJanAdharResponse {
  dynamic status;
  dynamic message;
  dynamic responseCode;
  dynamic transactionId;
  dynamic schemeCode;
  dynamic appCode;
  dynamic tid;
  List<FetchJanAdharResponseData>? data;
  dynamic janId;

  FetchJanAdharResponse(
      {this.status,
        this.message,
        this.responseCode,
        this.transactionId,
        this.schemeCode,
        this.appCode,
        this.tid,
        this.data,
        this.janId});

  FetchJanAdharResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    transactionId = json['transactionId'];
    schemeCode = json['schemeCode'];
    appCode = json['appCode'];
    tid = json['tid'];
    if (json['data'] != null) {
      data = <FetchJanAdharResponseData>[];
      json['data'].forEach((v) {
        data!.add(new FetchJanAdharResponseData.fromJson(v));
      });
    }
    janId = json['janId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    data['transactionId'] = this.transactionId;
    data['schemeCode'] = this.schemeCode;
    data['appCode'] = this.appCode;
    data['tid'] = this.tid;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['janId'] = this.janId;
    return data;
  }
}

class FetchJanAdharResponseData {
  dynamic nAMEEN;
  dynamic nAMELL;
  dynamic mEMTYPE;
  dynamic sRDRMID;
  dynamic iSDEATH;
  dynamic fATHERNAMEEN;
  dynamic fATHERNAMELL;
  dynamic dOB;
  dynamic mOTHERNAMEEN;
  dynamic mOTHERNAMELL;
  dynamic cATEGORYDESCLL;
  dynamic gENDER;
  dynamic mARITALSTATUS;
  dynamic sPOUCENAMEEN;
  dynamic sPOUCENAMELL;
  dynamic mOBILENO;
  dynamic eMAIL;
  dynamic iSORPHAN;
  dynamic bANK;
  dynamic aCCOUNTNO;
  dynamic iFSCCODE;
  dynamic rELWITHHOF;
  dynamic eDUCATION;
  dynamic pINCODE;
  dynamic bANKBRANCH;
  dynamic aADHARREFID;
  dynamic aDDRESS;
  dynamic bLOCKCITY;
  dynamic cASTECODE;
  dynamic cATEGORYDESCENG;
  dynamic dISTRICT;
  dynamic eNRID;
  dynamic gPWARD;
  dynamic iSMINORITY;
  dynamic jANAADHAR;
  dynamic mICR;
  dynamic pPONO;
  dynamic vILLAGENAME;
  dynamic eKYC;
  dynamic dISABILITYTYPE;
  dynamic dISTRICTCD;
  dynamic bLOCKCITYCD;
  dynamic gPWARDCD;
  dynamic vILLAGECD;
  dynamic dISABILITYPERCENTAGE;
  dynamic aDDRESSLL;
  dynamic dISTRICTNAMELL;
  dynamic bLOCKCITYLL;
  dynamic gPLL;
  dynamic wARDLL;
  dynamic vILLAGELL;
  dynamic cATEGORYCODE;
  dynamic iSDISABILITY;

  FetchJanAdharResponseData(
      {this.nAMEEN,
        this.nAMELL,
        this.mEMTYPE,
        this.sRDRMID,
        this.iSDEATH,
        this.fATHERNAMEEN,
        this.fATHERNAMELL,
        this.dOB,
        this.mOTHERNAMEEN,
        this.mOTHERNAMELL,
        this.cATEGORYDESCLL,
        this.gENDER,
        this.mARITALSTATUS,
        this.sPOUCENAMEEN,
        this.sPOUCENAMELL,
        this.mOBILENO,
        this.eMAIL,
        this.iSORPHAN,
        this.bANK,
        this.aCCOUNTNO,
        this.iFSCCODE,
        this.rELWITHHOF,
        this.eDUCATION,
        this.pINCODE,
        this.bANKBRANCH,
        this.aADHARREFID,
        this.aDDRESS,
        this.bLOCKCITY,
        this.cASTECODE,
        this.cATEGORYDESCENG,
        this.dISTRICT,
        this.eNRID,
        this.gPWARD,
        this.iSMINORITY,
        this.jANAADHAR,
        this.mICR,
        this.pPONO,
        this.vILLAGENAME,
        this.eKYC,
        this.dISABILITYTYPE,
        this.dISTRICTCD,
        this.bLOCKCITYCD,
        this.gPWARDCD,
        this.vILLAGECD,
        this.dISABILITYPERCENTAGE,
        this.aDDRESSLL,
        this.dISTRICTNAMELL,
        this.bLOCKCITYLL,
        this.gPLL,
        this.wARDLL,
        this.vILLAGELL,
        this.cATEGORYCODE,
        this.iSDISABILITY});

  FetchJanAdharResponseData.fromJson(Map<String, dynamic> json) {
    nAMEEN = json['NAME_EN'];
    nAMELL = json['NAME_LL'];
    mEMTYPE = json['MEM_TYPE'];
    sRDRMID = json['SRDR_MID'];
    iSDEATH = json['IS_DEATH'];
    fATHERNAMEEN = json['FATHER_NAME_EN'];
    fATHERNAMELL = json['FATHER_NAME_LL'];
    dOB = json['DOB'];
    mOTHERNAMEEN = json['MOTHER_NAME_EN'];
    mOTHERNAMELL = json['MOTHER_NAME_LL'];
    cATEGORYDESCLL = json['CATEGORY_DESC_LL'];
    gENDER = json['GENDER'];
    mARITALSTATUS = json['MARITAL_STATUS'];
    sPOUCENAMEEN = json['SPOUCE_NAME_EN'];
    sPOUCENAMELL = json['SPOUCE_NAME_LL'];
    mOBILENO = json['MOBILE_NO'];
    eMAIL = json['EMAIL'];
    iSORPHAN = json['IS_ORPHAN'];
    bANK = json['BANK'];
    aCCOUNTNO = json['ACCOUNT_NO'];
    iFSCCODE = json['IFSC_CODE'];
    rELWITHHOF = json['REL_WITH_HOF'];
    eDUCATION = json['EDUCATION'];
    pINCODE = json['PIN_CODE'];
    bANKBRANCH = json['BANK_BRANCH'];
    aADHARREFID = json['AADHAR_REF_ID'];
    aDDRESS = json['ADDRESS'];
    bLOCKCITY = json['BLOCK_CITY'];
    cASTECODE = json['CASTE_CODE'];
    cATEGORYDESCENG = json['CATEGORY_DESC_ENG'];
    dISTRICT = json['DISTRICT'];
    eNRID = json['ENR_ID'];
    gPWARD = json['GP_WARD'];
    iSMINORITY = json['IS_MINORITY'];
    jANAADHAR = json['JAN_AADHAR'];
    mICR = json['MICR'];
    pPONO = json['PPO_NO'];
    vILLAGENAME = json['VILLAGE_NAME'];
    eKYC = json['EKYC'];
    dISABILITYTYPE = json['DISABILITY_TYPE'];
    dISTRICTCD = json['DISTRICT_CD'];
    bLOCKCITYCD = json['BLOCK_CITY_CD'];
    gPWARDCD = json['GP_WARD_CD'];
    vILLAGECD = json['VILLAGE_CD'];
    dISABILITYPERCENTAGE = json['DISABILITY_PERCENTAGE'];
    aDDRESSLL = json['ADDRESS_LL'];
    dISTRICTNAMELL = json['DISTRICT_NAME_LL'];
    bLOCKCITYLL = json['BLOCK_CITY_LL'];
    gPLL = json['GP_LL'];
    wARDLL = json['WARD_LL'];
    vILLAGELL = json['VILLAGE_LL'];
    cATEGORYCODE = json['CATEGORY_CODE'];
    iSDISABILITY = json['IS_DISABILITY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME_EN'] = this.nAMEEN;
    data['NAME_LL'] = this.nAMELL;
    data['MEM_TYPE'] = this.mEMTYPE;
    data['SRDR_MID'] = this.sRDRMID;
    data['IS_DEATH'] = this.iSDEATH;
    data['FATHER_NAME_EN'] = this.fATHERNAMEEN;
    data['FATHER_NAME_LL'] = this.fATHERNAMELL;
    data['DOB'] = this.dOB;
    data['MOTHER_NAME_EN'] = this.mOTHERNAMEEN;
    data['MOTHER_NAME_LL'] = this.mOTHERNAMELL;
    data['CATEGORY_DESC_LL'] = this.cATEGORYDESCLL;
    data['GENDER'] = this.gENDER;
    data['MARITAL_STATUS'] = this.mARITALSTATUS;
    data['SPOUCE_NAME_EN'] = this.sPOUCENAMEEN;
    data['SPOUCE_NAME_LL'] = this.sPOUCENAMELL;
    data['MOBILE_NO'] = this.mOBILENO;
    data['EMAIL'] = this.eMAIL;
    data['IS_ORPHAN'] = this.iSORPHAN;
    data['BANK'] = this.bANK;
    data['ACCOUNT_NO'] = this.aCCOUNTNO;
    data['IFSC_CODE'] = this.iFSCCODE;
    data['REL_WITH_HOF'] = this.rELWITHHOF;
    data['EDUCATION'] = this.eDUCATION;
    data['PIN_CODE'] = this.pINCODE;
    data['BANK_BRANCH'] = this.bANKBRANCH;
    data['AADHAR_REF_ID'] = this.aADHARREFID;
    data['ADDRESS'] = this.aDDRESS;
    data['BLOCK_CITY'] = this.bLOCKCITY;
    data['CASTE_CODE'] = this.cASTECODE;
    data['CATEGORY_DESC_ENG'] = this.cATEGORYDESCENG;
    data['DISTRICT'] = this.dISTRICT;
    data['ENR_ID'] = this.eNRID;
    data['GP_WARD'] = this.gPWARD;
    data['IS_MINORITY'] = this.iSMINORITY;
    data['JAN_AADHAR'] = this.jANAADHAR;
    data['MICR'] = this.mICR;
    data['PPO_NO'] = this.pPONO;
    data['VILLAGE_NAME'] = this.vILLAGENAME;
    data['EKYC'] = this.eKYC;
    data['DISABILITY_TYPE'] = this.dISABILITYTYPE;
    data['DISTRICT_CD'] = this.dISTRICTCD;
    data['BLOCK_CITY_CD'] = this.bLOCKCITYCD;
    data['GP_WARD_CD'] = this.gPWARDCD;
    data['VILLAGE_CD'] = this.vILLAGECD;
    data['DISABILITY_PERCENTAGE'] = this.dISABILITYPERCENTAGE;
    data['ADDRESS_LL'] = this.aDDRESSLL;
    data['DISTRICT_NAME_LL'] = this.dISTRICTNAMELL;
    data['BLOCK_CITY_LL'] = this.bLOCKCITYLL;
    data['GP_LL'] = this.gPLL;
    data['WARD_LL'] = this.wARDLL;
    data['VILLAGE_LL'] = this.vILLAGELL;
    data['CATEGORY_CODE'] = this.cATEGORYCODE;
    data['IS_DISABILITY'] = this.iSDISABILITY;
    return data;
  }
}
