import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../department/dept_QR_scan/dept_QR_scan.dart';
import '../../department/dept_join_attendance_list/modal/financial_year_modal.dart';
// import '../../job_seeker/qr_scanner/qr_scanner_screen.dart';
import '../emp_QR_scan/emp_QR_scan.dart';
import 'provider/job_application_provider.dart';

class JobApplicationScreen extends StatefulWidget {
  const JobApplicationScreen({super.key});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {

  String? selectedEvent;
  String? selectedJobPostID;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<JobApplicationProvider>(context, listen: false);
      provider.clearData();
      provider.getFinancialYearApi(context);
      provider.getEventNameListApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: commonAppBar2("Job Application List", context, "en", "", false, "", onTapClick: () {}),

      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [

                /// 🔹 SCAN QR BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      _openQRScanner(context);
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan QR"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔹 FILTER CARD
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: const Text(
                      "Filters",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.filter_list),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [

                            /// Financial Year
                            labelWithStar('Financial Year', required: false),

                            DropdownButtonFormField<FinancialYearData>(
                              value: provider.selectedFinancialYear,
                              decoration: _inputDecoration("--Select Financial Year--"),
                              items: provider.financialYearList
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.financialYearName ?? ""),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                provider.selectedFinancialYear = value;
                                provider.notifyListeners();
                              },
                            ),

                            const SizedBox(height: 10),

                            /// Event Name
                            labelWithStar('Event Name', required: false),

                            buildDropdownWithBorderField(
                              items: provider.eventNameList,
                              controller: provider.eventNameController,
                              idController: provider.eventIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                setState(() {
                                  selectedEvent = provider.eventIdController.text;

                                  provider.jobPostListApi(
                                      context,
                                      eventId: selectedEvent
                                  );
                                });
                              },
                            ),

                            const SizedBox(height: 10),

                            /// Job Post
                            labelWithStar('Job Post', required: false),

                            buildDropdownWithBorderFieldOnlyThisPage(
                              items: provider.postList,
                              controller: provider.postNameController,
                              idController: provider.postIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                setState(() {
                                  selectedJobPostID = provider.postIdController.text;
                                });
                              },
                            ),

                            const SizedBox(height: 10),

                            /// Mobile
                            labelWithStar('Mobile Number', required: false),

                            TextFormField(
                              controller: provider.mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration("Enter Mobile Number"),
                            ),

                            const SizedBox(height: 10),

                            /// Registration
                            labelWithStar('Event Registration Number', required: false),

                            TextFormField(
                              controller: provider.registrationController,
                              decoration: _inputDecoration("Enter Registration Number"),
                            ),

                            const SizedBox(height: 10),

                            /// Applicant Name
                            labelWithStar('Name of Applicant', required: false),

                            TextFormField(
                              controller: provider.applicantNameController,
                              decoration: _inputDecoration("Enter Applicant Name"),
                            ),

                            const SizedBox(height: 10),

                            /// SEARCH
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  provider.getJobApplicationList(
                                    context,
                                    yearId: provider.selectedFinancialYear?.financialYearID,
                                    eventId: provider.eventIdController.text,
                                    jobPostID: selectedJobPostID,
                                    mobile: provider.mobileController.text,
                                    registrationNo: provider.registrationController.text,
                                    applicantName: provider.applicantNameController.text,
                                  );
                                },
                                child: const Text("Search"),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /// 🔹 LIST
                ListView.builder(
                  itemCount: provider.jobApplicationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = provider.jobApplicationList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade50],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const Icon(Icons.work, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const Divider(),

                          _buildRow("Mobile No.", data.mobileNo),
                          _buildRow("Email", data.email),
                          _buildRow("Job Position", data.jobPositionTitle),
                          _buildRow("Status", data.candidateStatus),

                          if ((data.candidateStatus ?? "").toLowerCase() == "pending")
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.person_add_alt_1, color: Colors.green),
                                onPressed: () {
                                  _openActionDialog(context, data);
                                },
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDropdownWithBorderFieldOnlyThisPage<T>({
    required List<dynamic> items,
    required TextEditingController controller,
    required TextEditingController idController,
    String? hintText,
    double? width,
    double? height,
    String? type,
    Color? color,
    Widget? postfixIcon,
    bool isEnable = true,
    Function(String?)? onChanged,
    BorderRadius? borderRadius,
  }) {
    String? selectedValue =
    items.any((item) => item.dropID.toString() == idController.text)
        ? idController.text
        : null;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return  Container(
          width: width ?? double.infinity,
          height: height ?? 50.0,
          decoration: BoxDecoration(
            color: color ?? kWhite,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.5),
          ),
          child: Center(
            child: DropdownButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              dropdownColor:kWhite,
              value: selectedValue,
              // Ensured valid
              isExpanded: true,
              hint: Text(
                hintText ?? 'Select an option',
                style: Styles.regularTextStyle(
                    size: 14, color:fontGrayColor),
              ),
              icon: postfixIcon ?? const Icon(Icons.arrow_drop_down, color: fontGrayColor),
              style: Styles.regularTextStyle(
                  size: 14, color: kBlackColor),
              underline: const SizedBox(),
              // Removes the default underline
              items: items.map((dynamic item) {
                return DropdownMenuItem<String>(
                  value: item.dropID.toString(), // ✅ ID
                  child: Text(item.name ?? ""),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                  final selectedItem = items.firstWhere(
                          (item) => item.dropID.toString() == newValue
                  );
                  controller.text = selectedItem.name ?? "";
                  idController.text = selectedItem.dropID.toString();
                  if (onChanged != null) {
                    onChanged(newValue);
                  }
                });
              },
            ),
          ) ,
        ) ;
      },
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label :",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(value ?? ""),
          ),
        ],
      ),
    );
  }
}

void _openQRScanner(BuildContext context) async {
  // TODO: Integrate actual scanner package
  // Example using mobile_scanner or qr_code_scanner

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const EmpQRScanPage(),
    ),
  );

  if (result == "scanned") {
    // final provider =
    // Provider.of<JobApplicationProvider>(context, listen: false);
    //
    // /// Example: fill registration number from QR
    // provider.registrationController.text = result;
    //
    // /// Optional: auto search
    // provider.getJobApplicationList(
    //   context,
    //   yearId: provider.selectedFinancialYear?.financialYearID,
    //   eventId: provider.eventIdController.text,
    //   jobPostID: provider.postIdController.text,
    //   mobile: provider.mobileController.text,
    //   registrationNo: result,
    //   applicantName: provider.applicantNameController.text,
    // );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blue),
    ),
  );
}

void _openActionDialog(BuildContext context, data) {

  int reachedStall = -1;
  int candidateShortlisted = -1;
  int selectionType = -1;

  TextEditingController salaryController = TextEditingController();
  TextEditingController joiningPlaceController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  /// ✅ ALSO RESET PROVIDER FILE
  final provider = Provider.of<JobApplicationProvider>(context, listen: false);
  provider.selectedDocumentFile = null;
  provider.uploadedDocumentPath = null;

  showDialog(
    context: context,
    builder: (context) {

      return StatefulBuilder(
        builder: (context, setState) {

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// CLOSE BUTTON
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ),

                    /// Reached Stall
                    const Text(
                      "Reached at Stall?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: reachedStall,
                          onChanged: (v) {
                            setState(() {
                              reachedStall = v!;

                              /// ✅ DEFAULT "NO" SELECTED
                              candidateShortlisted = 0;
                              selectionType = -1;
                            });
                          },
                        ),
                        const Text("Yes"),

                        Radio(
                          value: 0,
                          groupValue: reachedStall,
                          onChanged: (v) {
                            setState(() {
                              reachedStall = v!;

                              /// RESET
                              candidateShortlisted = -1;
                              selectionType = -1;
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                    /// STEP 2
                    if (reachedStall == 1) ...[

                      const SizedBox(height: 15),

                      const Text(
                        "Candidate Shortlisted?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: candidateShortlisted,
                            onChanged: (v) {
                              setState(() {
                                candidateShortlisted = v!;

                                /// ✅ DEFAULT SELECTION TYPE
                                if (candidateShortlisted == 1) {
                                  selectionType = 1; // Job Offer Letter Given
                                }
                              });
                            },
                          ),
                          const Text("Yes"),

                          Radio(
                            value: 0,
                            groupValue: candidateShortlisted,
                            onChanged: (v) {
                              setState(() {
                                candidateShortlisted = v!;

                                /// RESET
                                selectionType = -1;
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],

                    /// STEP 3
                    if (candidateShortlisted == 1) ...[

                      const SizedBox(height: 15),

                      const Text("Selection type"),

                      Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: [

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: selectionType,
                                onChanged: (v) {
                                  setState(() {
                                    selectionType = v!;
                                  });
                                },
                              ),
                              const Text("Job Offer Letter Given"),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: 2,
                                groupValue: selectionType,
                                onChanged: (v) {
                                  setState(() {
                                    selectionType = v!;
                                  });
                                },
                              ),
                              const Text("Preliminary Selected"),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Salary
                      TextField(
                        controller: salaryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Salary Offered (Per Month)",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Joining Date
                      TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Tentative date of joining",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {

                          DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now(),
                          );

                          if (picked != null) {
                            setState(() {
                              dateController.text =
                              "${picked.day}-${picked.month}-${picked.year}";
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 10),

                      /// Joining Place
                      TextField(
                        controller: joiningPlaceController,
                        decoration: const InputDecoration(
                          labelText: "Joining Place",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Upload Offer Letter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // const Text(
                          //   "Upload Offer Letter",
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          //
                          // const SizedBox(height: 8),

                          Consumer<JobApplicationProvider>(
                            builder: (context, provider, _) {
                              return buildImageUploadBox(
                                title: "Upload Offer Letter",
                                imageFile: provider.selectedDocumentFile,
                                onTap: () {
                                  provider.pickAndUploadSingleDocument(context: context);
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Remarks
                      TextField(
                        controller: remarksController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Remarks",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    /// Submit
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final provider =
                          Provider.of<JobApplicationProvider>(context, listen: false);

                          /// Validation
                          if (reachedStall == -1) {
                            showAlertError("Please select Reached at Stall", context);
                            return;
                          }

                          int isReached = reachedStall;
                          int isShortlisted = candidateShortlisted == -1 ? 0 : candidateShortlisted;

                          String? formattedDate;

                          if (dateController.text.isNotEmpty) {
                            final parts = dateController.text.split("-");
                            formattedDate =
                            "${parts[2]}-${parts[1]}-${parts[0]} 00:00:00";
                          }

                          String selectionText = "";
                          if (selectionType == 1) {
                            selectionText = "Job Offer Letter Given";
                          } else if (selectionType == 2) {
                            selectionText = "Preliminary Selected";
                          }

                          bool success = await provider.saveCandidateStatusApi(
                            context,
                            data: data,
                            isReached: isReached,
                            isShortlisted: isShortlisted,
                            selectionTypeId: selectionType == -1 ? 0 : selectionType,
                            selectionType: selectionText,
                            salary: salaryController.text,
                            joiningDate: formattedDate,
                            joiningPlace: joiningPlaceController.text,
                            remarks: remarksController.text,
                          );

                          if (success) {

                            /// 1️⃣ CLOSE MAIN POPUP
                            Navigator.of(context, rootNavigator: true).pop();

                            /// 2️⃣ SHOW SUCCESS
                            successDialog(
                              context,
                              "Saved Successfully",
                                  (value) async {
                                if (value.toString() == "success") {

                                  /// 3️⃣ REFRESH LIST
                                  await provider.getJobApplicationList(
                                    context,
                                    yearId: provider.selectedFinancialYear?.financialYearID,
                                    eventId: provider.eventIdController.text,
                                    jobPostID: provider.postIdController.text,
                                    mobile: provider.mobileController.text,
                                    registrationNo: provider.registrationController.text,
                                    applicantName: provider.applicantNameController.text,
                                  );
                                }
                              },
                            );
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
Widget buildImageUploadBox({
  required String title,
  required File? imageFile,
  VoidCallback? onTap,
}) {
  final bool isPdf =
      imageFile != null && imageFile.path.toLowerCase().endsWith('.pdf');

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageFile == null
                ? const Center(
              child: Icon(Icons.cloud_upload, size: 30),
            )

            // ✅ PDF UI
                : isPdf
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 36,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    imageFile.path.split('/').last,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            )

            // ✅ IMAGE UI
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}