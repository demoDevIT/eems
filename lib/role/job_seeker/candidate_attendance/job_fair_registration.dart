import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:rajemployment/role/job_seeker/candidate_attendance/provider/job_fair_reg_provider.dart';

import '../../../constants/colors.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../counselor/counsellor_otr/modal/district_modal.dart';
import '../../employer/empotr_form/modal/sector_modal.dart';
import '../addeducationaldetail/modal/education_level_modal.dart';
import '../addeducationaldetail/modal/graduation_type_modal.dart';
import 'modal/caste_model.dart';
import 'modal/event_model.dart';

class JobFairRegistrationScreen extends StatefulWidget {
  const JobFairRegistrationScreen({super.key});

  @override
  State<JobFairRegistrationScreen> createState() =>
      _JobFairRegistrationScreenState();
}

class _JobFairRegistrationScreenState extends State<JobFairRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedSector;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final provider =
          Provider.of<JobFairRegistrationProvider>(context, listen: false);

      provider.clearData();

      ProgressDialog.showLoadingDialog(context);

      try {
        await Future.wait([
          provider.educationLevelApi(context, showLoader: false),
          provider.getDistrictMasterApi(context, showLoader: false),
          provider.getCasteMasterApi(context, showLoader: false),
          provider.sectorListApi(context, showLoader: false),
          provider.getEventList(context, showLoader: false),
        ]);
      } finally {
        ProgressDialog.closeLoadingDialog(context);
      }
    });
  }

  String? selectedEvent;

  InputDecoration commonDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Job Fair Registration"),
      ),
      body: Consumer<JobFairRegistrationProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// JOB DETAILS CARD
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSearchableDropdown<EventData>(
                                items: provider.eventList,
                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.eventId.toString(),
                                getName: (item) => item.eventNameEng ?? "",
                                controller: provider.eventNameController,
                                idController: provider.eventIdController,
                                hintText: "--Select Event--",

                                // onChanged: (value) {
                                //   provider.selectedEvent = value;
                                //   setState(() {
                                //     selectedEvent = value?.eventId.toString();
                                //   });
                                //
                                //   provider.notifyListeners();
                                // },
                                onChanged: (value) {
                                  provider.selectedEvent = value;

                                  provider.eventIdController.text =
                                      value?.eventId.toString() ?? "";

                                  provider.eventNameController.text =
                                      value?.eventNameEng ?? "";

                                  provider.resetSectorAndJobs();
                                }),
                            const SizedBox(height: 12),
                            TextField(
                              controller: provider.nameController,
                              decoration: commonDecoration("Name"),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: provider.fNameController,
                              decoration: commonDecoration("Father's name"),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Date of Birth',
                                  required: true),
                            ),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                showDatePickerDialog(
                                  context,
                                  provider.dateOfBirthController,
                                  DateTime.now(), // initialDate
                                  DateTime(1901),
                                  //DateTime(DateTime.now().year - 1), // firstDate
                                  DateTime.now(), // lastDate
                                ).then((_) {
                                  setState(() {});
                                }).catchError((error) {
                                  setState(() {});
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.dateOfBirthController,
                                  "Select Date of Birth",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  isEnabled: false,
                                  boxColor: fafafaColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: provider.mobileController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: commonDecoration("Mobile Number"),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Gender', required: false),
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'Male',
                                      groupValue:
                                          provider.genderController.text,
                                      onChanged: (val) {
                                        provider.genderController.text = val!;
                                        setState(() {});
                                      },
                                    ),
                                    const Text("Male"),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'Female',
                                      groupValue:
                                          provider.genderController.text,
                                      onChanged: (val) {
                                        provider.genderController.text = val!;
                                        setState(() {});
                                      },
                                    ),
                                    const Text("Female"),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'TransGender',
                                      groupValue:
                                          provider.genderController.text,
                                      onChanged: (val) {
                                        provider.genderController.text = val!;
                                        setState(() {});
                                      },
                                    ),
                                    const Text("TransGender"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: provider.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: commonDecoration("Email Address"),
                            ),
                            const SizedBox(height: 12),
                            buildSearchableDropdown<DistrictData>(
                              //enabled: false,
                              items: provider.districtList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.code.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.districtNameController,
                              idController: provider.districtIdController,
                              hintText: "--Select District--",
                              // height: 50,
                              // selectedValue: provider.selectedDistrict,
                              // getLabel: (e) => e.name ?? "",

                              onChanged: (value) {
                                provider.selectedDistrict = value;
                                provider.districtNameController.text =
                                    value?.name ?? "";
                                provider.districtIdController.text =
                                    value?.iD.toString() ?? "";
                                provider.notifyListeners();
                              },
                            ),
                            const SizedBox(height: 12),
                            buildSearchableDropdown<CasteData>(
                              items: provider.casteList,
                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.name.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.casteNameController,
                              idController: provider.casteIdController,
                              hintText: "--Select Caste--",

                              onChanged: (value) {
                                provider.casteDistrict = value;
                                provider.casteNameController.text =
                                    value?.name ?? "";
                                provider.casteIdController.text =
                                    value?.name.toString() ?? "";
                                provider.notifyListeners();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Territory Type',
                                  required: false),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Rural',
                                      groupValue:
                                          provider.territoryController.text,
                                      onChanged: (val) => setState(() =>
                                          provider.territoryController.text =
                                              val ??
                                                  provider.territoryController
                                                      .text),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Rural',
                                      style: Styles.mediumTextStyle(
                                          color: kBlackColor, size: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Urban',
                                      groupValue:
                                          provider.territoryController.text,
                                      onChanged: (val) => setState(() =>
                                          provider.territoryController.text =
                                              val ??
                                                  provider.territoryController
                                                      .text),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Urban',
                                      style: Styles.mediumTextStyle(
                                          color: kBlackColor, size: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(
                                  'Highest Education Qualification',
                                  required: false),
                            ),
                            IgnorePointer(
                              ignoring: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child:
                                    buildSearchableDropdown<EducationLevelData>(
                                  items: provider.educationLevelsList,

                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.dropID.toString(),
                                  getName: (item) => item.name ?? "",

                                  controller:
                                      provider.educationLevelNameController,
                                  idController:
                                      provider.educationLevelIdController,
                                  hintText: "--Select Option--",
                                  // height: 50,
                                  // color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) async {
                                    provider.graduationTypeNameController
                                        .clear();
                                    provider.graduationTypeIdController.clear();

                                    setState(() {});
                                    if (value.dropID == 5 ||
                                        value.dropID == 6 ||
                                        value.dropID == 8 ||
                                        value.dropID == 9) {
                                      await provider.graduationTypeApi(
                                          context, value.dropID.toString());

                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ),
                            provider.educationLevelIdController.text == "5" ||
                                    provider.educationLevelIdController.text ==
                                        "6" ||
                                    provider.educationLevelIdController.text ==
                                        "8" ||
                                    provider.educationLevelIdController.text ==
                                        "9"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: labelWithStar(
                                      "Graduation Type",
                                      required: true,
                                    ),
                                  )
                                : SizedBox(),
                            Visibility(
                              visible:
                                  provider.educationLevelIdController.text ==
                                              "5" ||
                                          provider.educationLevelIdController
                                                  .text ==
                                              "6" ||
                                          provider.educationLevelIdController
                                                  .text ==
                                              "8" ||
                                          provider.educationLevelIdController
                                                  .text ==
                                              "9"
                                      ? true
                                      : false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child:
                                    buildSearchableDropdown<GraduationTypeData>(
                                  items: provider.educationLevelIdController
                                              .text ==
                                          "9"
                                      ? provider.itiMainList
                                      : provider.graduationTypeList,

                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.dropID.toString(),
                                  getName: (item) => item.name ?? "",

                                  controller:
                                      provider.graduationTypeNameController,
                                  idController:
                                      provider.graduationTypeIdController,
                                  hintText: "--Select Option--",
                                  // height: 50,
                                  // color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    setState(() {
                                      String id = provider
                                          .graduationTypeIdController.text;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: labelWithStar(
                                "Search by Job Sector",
                                required: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: buildSearchableDropdown<SectorData>(
                                  items: provider.sectorList,

                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.iD.toString(),
                                  getName: (item) => item.name ?? "",
                                  controller: provider.sectorNameController,
                                  idController: provider.sectorIdController,
                                  hintText: "--Select Option--",
                                  // height: 50,
                                  // color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) async {
                                    provider.sectorNameController.text =
                                        value?.name ?? "";

                                    provider.sectorIdController.text =
                                        value?.iD.toString() ?? "0";

                                    await provider.getMatchedJobPostedList(
                                      context,
                                      value?.iD ?? 0,
                                    );
                                  }),
                            ),
                            const SizedBox(height: 20),
                            if (provider.matchedJobList.isNotEmpty)
                              Text(
                                "Note : Each job seeker may apply to up to 5 jobs at an event.",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              itemCount: provider.matchedJobList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = provider.matchedJobList[index];

                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: item.isSelected,
                                              onChanged: (value) {
                                                if (value == true &&
                                                    provider.selectedJobCount >=
                                                        5) {
                                                  showAlertError(
                                                      "You can select maximum 5 jobs.",
                                                      context);

                                                  return;
                                                }

                                                item.isSelected =
                                                    value ?? false;

                                                provider.notifyListeners();
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                item.jobPositionTitleEng ?? "",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          "Location : ${item.preferedLocation}",
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          "Salary : "
                                          "${item.minSalary}-${item.maxSalary}",
                                        ),

                                        // const SizedBox(height: 8),
                                        //
                                        // Text(
                                        //   item.action ?? "",
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            // onPressed: () {
                            //   if (validateJobFairRegistration(context, provider)) {
                            //     confirmAlertDialog(
                            //       context,
                            //       "Alert",
                            //       "Are you sure want to submit?",
                            //           (value) {
                            //         if (value.toString() == "success") {
                            //           //provider.saveJobFairRegistrationApi(context);
                            //         }
                            //       },
                            //     );
                            //   }
                            // },

                            onPressed: () {
                              if (!validateJobFairRegistration(
                                  context, provider)) {
                                return;
                              }

                              if (!validateSelectedJobs(context, provider)) {
                                return;
                              }

                              confirmAlertDialog(
                                context,
                                "Alert",
                                "Are you sure you want to submit?",
                                (value) async {
                                  if (value.toString() == "success") {
                                    await provider
                                        .saveJobFairRegistration(context);
                                  }
                                },
                              );
                            },

                            child: const Text("Submit"),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 30)
                  ],
                ),
              ));
        },
      ),
    );
  }
}

bool validateSelectedJobs(
  BuildContext context,
  JobFairRegistrationProvider provider,
) {
  final selected = provider.matchedJobList.where((e) => e.isSelected).toList();

  if (selected.isEmpty) {
    showAlertError(
      "Please select at least one job.",
      context,
    );
    return false;
  }

  return true;
}

bool validateJobFairRegistration(
  BuildContext context,
  JobFairRegistrationProvider provider,
) {
  // Event Name
  if (provider.eventIdController.text.trim().isEmpty) {
    showAlertError("Please select Event", context);
    return false;
  }

  // Name
  if (provider.nameController.text.trim().isEmpty) {
    showAlertError("Please enter Name", context);
    return false;
  }

  // Father's Name
  if (provider.fNameController.text.trim().isEmpty) {
    showAlertError("Please enter Father's Name", context);
    return false;
  }

  // DOB
  if (provider.dateOfBirthController.text.trim().isEmpty) {
    showAlertError("Please select Date of Birth", context);
    return false;
  }

  // Mobile Number
  if (provider.mobileController.text.trim().isEmpty) {
    showAlertError("Please enter Mobile Number", context);
    return false;
  }

  if (provider.mobileController.text.length != 10) {
    showAlertError("Please enter a valid Mobile Number", context);
    return false;
  }

  // Gender
  if (provider.genderController.text.trim().isEmpty) {
    showAlertError("Please select Gender", context);
    return false;
  }

  // Email
  if (provider.emailController.text.trim().isEmpty) {
    showAlertError("Please enter Email Address", context);
    return false;
  }

  final emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  if (!emailRegex.hasMatch(provider.emailController.text.trim())) {
    showAlertError("Please enter a valid Email Address", context);
    return false;
  }

  // District
  if (provider.districtIdController.text.trim().isEmpty) {
    showAlertError("Please select District", context);
    return false;
  }

  // Caste
  if (provider.casteIdController.text.trim().isEmpty) {
    showAlertError("Please select Caste", context);
    return false;
  }

  // Territory
  if (provider.territoryController.text.trim().isEmpty) {
    showAlertError("Please select Territory Type", context);
    return false;
  }

  // Education
  if (provider.educationLevelIdController.text.trim().isEmpty) {
    showAlertError("Please select Highest Education Qualification", context);
    return false;
  }

  // Graduation Type (Required for 5,6,8,9)
  if (provider.educationLevelIdController.text == "5" ||
      provider.educationLevelIdController.text == "6" ||
      provider.educationLevelIdController.text == "8" ||
      provider.educationLevelIdController.text == "9") {
    if (provider.graduationTypeIdController.text.trim().isEmpty) {
      showAlertError("Please select Graduation Type", context);
      return false;
    }
  }

  // Sector
  if (provider.sectorIdController.text.trim().isEmpty) {
    showAlertError("Please select Job Sector", context);
    return false;
  }

  return true;
}
