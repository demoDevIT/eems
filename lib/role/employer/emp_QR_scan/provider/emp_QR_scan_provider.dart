import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/location_service.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../job_application/provider/job_application_provider.dart';

class EmpQRScanProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  EmpQRScanProvider({required this.commonRepo});

  Future<void> handleQRCode(BuildContext context, String rawData) async {
    print("EMPPPP QR Raw Data-=======>: $rawData");
    //[{"EventRegistrationId":"3200340037003900","Longitude":"320031003300320031003300",
    // "Latitude":"3200310033003200", "UserId":"3200320036003100360039003800",
    // "Roleid":"3400","EventId":"3100300037003600"}]
    try {

      ProgressDialog.showLoadingDialog(context);

      final decoded = jsonDecode(rawData);

      String eventRegId = decoded[0]['EventRegistrationId'];
      String longitude = decoded[0]['Longitude'];
      String latitude = decoded[0]['Latitude'];
      String jobSeekerUserId = decoded[0]['UserId'];
      String jobSeekerRoleId = decoded[0]['Roleid'];
      String jobSeekerEventId = decoded[0]['EventId'];

      // print("EventRegId===>: $eventRegId");
      // print("Longitude===>: $longitude");
      // print("Latitude===>: $latitude");
      print("jobSeekerUserId===>: $jobSeekerUserId");
      print("jobSeekerRoleId===>: $jobSeekerRoleId");
      print("jobSeekerEventId===>: $jobSeekerEventId");

      final jobProvider =
      Provider.of<JobApplicationProvider>(context, listen: false);
      await jobProvider.getJobApplicationList(
        context,
        isScanner: true,
        jobSeekerUserId: jobSeekerUserId,
        jobSeekerRoleId: jobSeekerRoleId,
        jobSeekerEventId: jobSeekerEventId,
      );

      ProgressDialog.closeLoadingDialog(context);

      /// ✅ GO BACK WITH RESULT
      Navigator.pop(context, "scanned");

    } catch (e) {

      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);

    }
  }

}