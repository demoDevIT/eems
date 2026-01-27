import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class EmpOTRFormProvider with ChangeNotifier {
  final CommonRepo commonRepo;

  EmpOTRFormProvider({required this.commonRepo});

  // -------- Controllers --------

  /// 1. Basic Details
  final TextEditingController ssoController = TextEditingController();
  final TextEditingController brnController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController tehsilController = TextEditingController();
  final TextEditingController localBodyController = TextEditingController();

  /// 2. Branch Office Details
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController laneController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController telNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController panHolderController = TextEditingController();
  final TextEditingController panVerifiedController = TextEditingController();
  final TextEditingController tanController = TextEditingController();

  /// 3. Head Office Details
  final TextEditingController hoCompanyNameController = TextEditingController();
  final TextEditingController hoTelNoController = TextEditingController();
  final TextEditingController hoEmailController = TextEditingController();
  final TextEditingController hoPanController = TextEditingController();
  final TextEditingController hoHouseNoController = TextEditingController();
  final TextEditingController hoLaneController = TextEditingController();
  final TextEditingController hoLocalityController = TextEditingController();
  final TextEditingController hoPincodeController = TextEditingController();

  /// 4. Head Office Applicant Details
  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController applicantMobileController = TextEditingController();
  final TextEditingController applicantEmailController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController ownershipController = TextEditingController();
  final TextEditingController totalPersonController = TextEditingController();
  final TextEditingController actAuthorityRegController = TextEditingController();
  final TextEditingController tanNoController = TextEditingController();
  final TextEditingController hoApplicantEmailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController nicCodeController = TextEditingController();
  final TextEditingController applicantAddressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtHoController = TextEditingController();
  final TextEditingController cityHoController = TextEditingController();

  /// 5. Contact Person Details
  final TextEditingController contactPanController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactMobileController = TextEditingController();
  final TextEditingController contactAltMobileController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactDesignationController = TextEditingController();
  final TextEditingController contactDepartmentController = TextEditingController();
  final TextEditingController contactPincodeController = TextEditingController();
  final TextEditingController contactStateController = TextEditingController();
  final TextEditingController contactDistrictController = TextEditingController();
  final TextEditingController contactCityController = TextEditingController();
  final TextEditingController contactAddressController = TextEditingController();

  /// 6. Exchange Name / District Employment Office
  final TextEditingController exchangeNameController = TextEditingController();

  /// 7. Exchange Market Information Program
  final TextEditingController organisationTypeController = TextEditingController();
  final TextEditingController govtBodyController = TextEditingController();
  final TextEditingController noOfMaleEmpController = TextEditingController();
  final TextEditingController noOfFemaleEmpController = TextEditingController();
  final TextEditingController noOfTransEmpController = TextEditingController();
  final TextEditingController noOfTotalEmpController = TextEditingController();
  final TextEditingController actEstController = TextEditingController();
  final TextEditingController industryTypetController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();

  /// 8. Upload Organization/Company Documents
  final TextEditingController panCertificateController = TextEditingController();
  final TextEditingController tanCertificateController = TextEditingController();
  final TextEditingController gstCertificateController = TextEditingController();
  final TextEditingController logoController = TextEditingController();

  String areaType = "Rural";

  // -------- Methods --------

  void setSSO(String ssoId) {
    ssoController.text = ssoId;
  }

  void setArea(String? value) {
    if (value == null) return;
    areaType = value;
    notifyListeners();
  }

  void submitEmpOTRForm(BuildContext context) {
    // TEMP: bypass API
    debugPrint("Emp OTR Form Submitted");
    debugPrint("SSO: ${ssoController.text}");
    debugPrint("Area: $areaType");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form saved successfully (mock)")),
    );
  }

  void clearData() {
    ssoController.clear();
    brnController.clear();
    districtController.clear();
    tehsilController.clear();
    localBodyController.clear();
    companyNameController.clear();
    houseNoController.clear();
    laneController.clear();
    localityController.clear();
    pinCodeController.clear();
    telNoController.clear();
    emailController.clear();
    gstController.clear();
    panController.clear();
    panHolderController.clear();
    panVerifiedController.clear();
    tanController.clear();

    areaType = "Rural";
  }
}
