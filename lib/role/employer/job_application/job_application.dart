import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/textfeild.dart';
import '../../department/dept_join_attendance_list/modal/financial_year_modal.dart';
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
            child: Column(
              children: [
                /// FILTER CARD
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                      initiallyExpanded: false,
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
                      // Financial Year
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            labelWithStar('Financial Year', required: false),

                                    DropdownButtonFormField<FinancialYearData>(
                                      value: provider.selectedFinancialYear,
                                      decoration: _inputDecoration("--Select Financial Year--"),
                                      items: provider.financialYearList
                                          .map(
                                            (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.financialYearName ?? ""),
                                        ),
                                      )
                                          .toList(),
                                      onChanged: (value) {
                                        provider.selectedFinancialYear = value;
                                        provider.notifyListeners();
                                      },
                                    ),
                            const SizedBox(height: 10),
                            // IgnorePointer(
                            //   ignoring: false,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            //     child: buildDropdownWithBorderField(
                            //       items: provider.financialYearList,
                            //       controller: provider.financialYearName,
                            //       idController: provider.selectedFinancialYear,
                            //       hintText: "--Select Option--",
                            //       height: 50,
                            //       color: Colors.transparent,
                            //       borderRadius: BorderRadius.circular(8),
                            //       onChanged: (value) {
                            //         setState(() {
                            //           //selectedEvent = provider.selectedFinancialYear.text;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),

                            labelWithStar('Event Name', required: false),

                            IgnorePointer(
                              ignoring: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                child: buildDropdownWithBorderField(
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
                              ),
                            ),

                          ],
                        ),


                        const SizedBox(height: 10),

                        labelWithStar('Job Post', required: false),

                        IgnorePointer(
                          ignoring: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: buildDropdownWithBorderField(
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
                          ),
                        ),

                        const SizedBox(height: 10),

                        labelWithStar('Mobile Number', required: false),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: provider.mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: _inputDecoration("Enter Mobile Number"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        labelWithStar('Event Registration Number', required: false),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: provider.registrationController,
                            decoration: _inputDecoration("Enter Registration Number"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Applicant Name
                        labelWithStar('Name of Applicant', required: false),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: provider.applicantNameController,
                            decoration: _inputDecoration("Enter Applicant Name"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// SEARCH BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.getJobApplicationList(
                                  context,
                                yearId: provider.selectedFinancialYear.toString(),
                                eventId: selectedEvent,
                                jobPostID: selectedJobPostID,
                                mobile: provider.mobileController.text,
                                registrationNo: provider.registrationController.text,
                                applicantName: provider.applicantNameController.text,
                              );
                            },
                            child: const Text("Search"),
                          ),
                        )
                      ],
                    ),
                  )
              ],
                ),
                ),

                const SizedBox(height: 15),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.jobApplicationList.length,
                    itemBuilder: (context, index) {

                      final data = provider.jobApplicationList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
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
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const Icon(Icons.work, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data.name, //data.eventName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const Divider(),

                              _buildRow("Mobile No.", data.mobileNo),//data.sectorName
                              _buildRow("Email", data.email),
                              _buildRow("Job Position", data.jobPositionTitle),
                              _buildRow("Status", data.candidateStatus),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [


                                  IconButton(
                                    icon: const Icon(Icons.person_add_alt_1, color: Colors.green),
                                    onPressed: () {
                                      _openActionDialog(context, data);
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
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

                      Row(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text("Upload Offer Letter"),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.upload),
                            label: const Text("Attach File"),
                            onPressed: () {

                              /// use image_picker or file_picker here

                            },
                          )
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
                        onPressed: () {

                          /// call submit API here

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