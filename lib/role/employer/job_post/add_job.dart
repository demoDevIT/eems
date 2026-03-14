import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import 'modal/location_modal.dart';
import 'provider/add_job_provider.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
 // const AddJobScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  String? selectedEvent;
  String? selectedSector;
  String? selectedjobTitle;
  String? selectedNcoCode;
  String? selectedgender;
  String? selectedLocation;
  String? selectedEmpType;
  String? selectedNatureJob;
  String? selectedSalaryRange;
  String? selectedworkExp;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddJobProvider>(context, listen: false);
      provider.clearData();
      provider.getEventNameListApi(context);
      provider.sectorListApi(context);
      provider.ncoCodeListApi(context);
      provider.genderListApi(context);
      provider.locationListApi(context);
      provider.empTypeListApi(context);
      provider.natureJobListApi(context);
      provider.salaryRangeListApi(context);
      provider.getCategoryTypeDetailsApi(context);
      provider.getEducationTypeApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Job"),
        ),
        body: Consumer<AddJobProvider>(
          builder: (context, provider, child) {

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                children: [

                  /// JOB DETAILS CARD
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Job Details",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 12),

                          /// EVENT
                          labelWithStar('Event', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// EVENT
                          labelWithStar('Job Sector', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.sectorList,
                              controller: provider.sectorNameController,
                              idController: provider.sectorIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {

                                setState(() {
                                  selectedSector = provider.sectorIdController.text;
                                  provider.jobTitleController.text = "";
                                });

                                if (selectedSector != null && selectedSector!.isNotEmpty) {
                                  provider.jobTitleListApi(
                                    context,
                                    int.parse(selectedSector!),
                                  );
                                }
                              },
                            ),
                          ),


                          const SizedBox(height: 10),

                          /// JOB TITLE
                          labelWithStar('Job Title', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.jobTitleList,
                              controller: provider.jobTitleController,
                              idController: provider.jobTitleIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                 selectedjobTitle = provider.jobTitleIdController.text;


                                  provider.jobTitleController.text = provider.jobTitleController.text;
                                 // provider.jobTitleIdController.text = value;

                                  provider.showJobTitleField = true;
                                  provider.notifyListeners();


                              },
                            ),
                          ),

                          const SizedBox(height: 10),
                          Consumer<AddJobProvider>(
                            builder: (context, provider, _) {

                              return Visibility(
                                visible: provider.showJobTitleField,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    const SizedBox(height: 10),

                                    labelWithStar('Job Title', required: false),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: TextField(
                                        controller: provider.jobTitleController,
                                        enabled: false, // disabled field
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),


                          /// NCO
                          labelWithStar('NCO Code', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.ncoCodeList,
                              controller: provider.ncoCodeController,
                              idController: provider.ncoCodeIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedNcoCode = provider.ncoCodeIdController.text;
                                provider.notifyListeners();
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// JOB DESCRIPTION FILE
                          labelWithStar('Job Description', required: false),
                          const SizedBox(height: 6),
                          Consumer<AddJobProvider>(
                            builder: (context, provider, _) {

                              return buildImageUploadBox(
                                title: "Upload Document (PDF)",
                                imageFile: provider.selectedDocumentFile,
                                onTap: () {
                                  provider.pickAndUploadSingleDocument(
                                    context: context,
                                  );
                                },
                              );

                            },
                          ),

                          const SizedBox(height: 10),

                          labelWithStar('Gender', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.genderList,
                              controller: provider.genderController,
                              idController: provider.genderIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedgender = provider.genderIdController.text;
                                provider.notifyListeners();
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// JOB LOCATION
                          labelWithStar('Job Location', required: false),

                          DropdownButtonFormField<String>(
                            hint: const Text("--Select Option--"),
                            value: provider.locationController.text.isEmpty
                                ? null
                                : provider.locationController.text,

                            items: [

                              ...provider.locationList.asMap().entries.expand((entry) {

                                int index = entry.key;
                                LocationData item = entry.value;

                                List<DropdownMenuItem<String>> list = [];

                                /// Insert label before cities
                                if (index == 2) {
                                  list.add(
                                    const DropdownMenuItem<String>(
                                      enabled: false,
                                      child: Text(
                                        "Rajasthan -> Cities",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                list.add(
                                  DropdownMenuItem<String>(
                                    value: item.name,
                                    enabled: true,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: index >= 2 ? 12 : 0),
                                      child: Text(
                                        item.name ?? "",
                                        style: TextStyle(
                                          fontWeight:
                                          (item.cityId == -100 || item.cityId == -99)
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                                return list;
                              }),

                            ],

                            onChanged: (value) {

                              provider.locationController.text = value ?? "";

                              /// Find selected object
                              final selected = provider.locationList
                                  .firstWhere((e) => e.name == value);

                              provider.locationIdController.text =
                                  selected.cityId.toString();

                              provider.notifyListeners();
                            },
                          ),

                          const SizedBox(height: 10),

                          /// EMPLOYMENT TYPE
                          labelWithStar('Employment Type', required: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.empTypeList,
                              controller: provider.empTypeController,
                              idController: provider.empTypeIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedEmpType = provider.empTypeIdController.text;
                                provider.notifyListeners();
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// NATURE OF JOB
                          labelWithStar('Nature Of Job', required: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.natureJobList,
                              controller: provider.natureJobController,
                              idController: provider.natureJobIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedNatureJob = provider.natureJobIdController.text;
                                provider.notifyListeners();
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// WORK EXPERIENCE
                          labelWithStar('Work Experience', required: false),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: buildDropdownWithBorderField(
                            items: provider.workExpList,
                            controller: provider.workExpController,
                            idController: provider.workExpIdController,
                            hintText: "--Select Option--",
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                            onChanged: (value) {
                              setState(() {
                                provider.workExpIdController.text = provider.workExpIdController.text;
                              });

                              if (provider.workExpController.text == "Experienced") {
                                provider.isExperienced = true;
                              } else {
                                provider.isExperienced = false;
                              }

                              provider.notifyListeners();

                            },
                          ),
                        ),

                          Consumer<AddJobProvider>(
                            builder: (context, provider, _) {

                              if (!provider.isExperienced) return const SizedBox();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  labelWithStar("Experience Limit", required: false),

                                  RangeSlider(
                                    min: 1,
                                    max: 30,
                                    divisions: 29,
                                    labels: RangeLabels(
                                      provider.experienceRange.start.round().toString(),
                                      provider.experienceRange.end.round().toString(),
                                    ),
                                    values: provider.experienceRange,
                                    onChanged: (values) {
                                      provider.experienceRange = values;
                                      provider.notifyListeners();
                                    },
                                  ),

                                  Text(
                                    "${provider.experienceRange.start.round()} - ${provider.experienceRange.end.round()} Years",
                                  ),

                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 15),

                          /// AGE SLIDER
                          const Text("Age Group Limit"),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Min: ${provider.minAge.round()} yrs"),
                              Text("Max: ${provider.maxAge.round()} yrs"),
                            ],
                          ),

                          RangeSlider(
                            values: RangeValues(
                                provider.minAge,
                                provider.maxAge),
                            min: 18,
                            max: 60,
                            divisions: 42,
                            labels: RangeLabels(
                                provider.minAge.round().toString(),
                                provider.maxAge.round().toString()),
                            onChanged: (values) {
                              provider.updateAge(values);
                            },
                          ),

                          const SizedBox(height: 10),

                          /// EX SERVICEMAN
                          const Text("Ex-Serviceman Preferred"),

                          Row(
                            children: [

                              Radio(
                                  value: "Yes",
                                  groupValue: provider.exServiceman,
                                  onChanged: (v) {
                                    provider.setExServiceman(v!);
                                  }),
                              const Text("Yes"),

                              Radio(
                                  value: "No",
                                  groupValue: provider.exServiceman,
                                  onChanged: (v) {
                                    provider.setExServiceman(v!);
                                  }),
                              const Text("No"),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// NIGHT SHIFT
                          const Text("This is a Night Shift Job"),

                          Row(
                            children: [

                              Radio(
                                  value: "Yes",
                                  groupValue: provider.nightShift,
                                  onChanged: (v) {
                                    provider.setNightShift(v!);
                                  }),
                              const Text("Yes"),

                              Radio(
                                  value: "No",
                                  groupValue: provider.nightShift,
                                  onChanged: (v) {
                                    provider.setNightShift(v!);
                                  }),
                              const Text("No"),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// PWD JOB
                          const Text("Job Post For PWD?"),

                          Row(
                            children: [

                              Radio(
                                  value: "Yes",
                                  groupValue: provider.pwdJob,
                                  onChanged: (v) {
                                    provider.setPwdJob(v!);
                                  }),
                              const Text("Yes"),

                              Radio(
                                  value: "No",
                                  groupValue: provider.pwdJob,
                                  onChanged: (v) {
                                    provider.setPwdJob(v!);
                                  }),
                              const Text("No"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// SALARY CARD
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Salary Range', required: false),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.salaryRangeList,
                              controller: provider.salaryRangeController,
                              idController: provider.salaryRangeIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedSalaryRange = provider.salaryRangeIdController.text;
                                provider.notifyListeners();
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: provider.salaryController,
                            decoration: const InputDecoration(
                              labelText: "Salary",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Required Skill",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 12),
                          labelWithStar('Skill Category', required: false),
                          /// CATEGORY DROPDOWN
                          buildDropdownWithBorderField(
                            items: provider.categoryList,
                            controller: provider.categoryNameController,
                            idController: provider.categoryIdController,
                            hintText: "--Select Option--",
                            height: 50,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            onChanged: (value) {
                              provider.selectedSkillCategory =
                                  provider.categoryNameController.text;

                              provider.getSubCategoryTypeDetailsApi(
                                context,
                                provider.categoryIdController.text,
                              );
                            },
                          ),
                          const SizedBox(height: 10),

                          /// SUBCATEGORY + ADD BUTTON

                          labelWithStar('Skill Subcategory', required: false),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: buildDropdownWithBorderField(
                                  items: provider.subCategoryList,
                                  controller: provider.subCategoryNameController,
                                  idController: provider.subCategoryIdController,
                                  hintText: "--Select Option--",
                                  height: 50,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    provider.selectedSkillSubCategory =
                                        provider.subCategoryNameController.text;
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () {
                                  provider.addSkill();
                                },
                              )
                            ],
                          ),

                          const SizedBox(height: 10),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.skills.length,
                            itemBuilder: (context, index) {

                              final q = provider.skills[index];

                              return Row(
                                children: [

                                  SizedBox(width: 40, child: Text("${index + 1}")),

                                  Expanded(child: Text(q.category)),

                                  Expanded(child: Text(q.subCategory)),

                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      provider.removeSkill(index);
                                    },
                                  )
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),

                  /// QUALIFICATION CARD
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Essential Qualification",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 12),
                          labelWithStar('Education Type', required: false),
                          buildDropdownWithBorderField(
                            items: provider.educationTypeList,
                            controller: provider.educationNameController,
                            idController: provider.educationIdController,
                            hintText: "--Select Option--",
                            height: 50,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            onChanged: (value) {
                              provider.selectedEducationType =
                                  provider.educationNameController.text;

                              provider.getCourseApi(
                                context,
                                provider.educationIdController.text,
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          labelWithStar('Course', required: false),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: buildDropdownWithBorderField(
                                  items: provider.courseList,
                                  controller: provider.courseNameController,
                                  idController: provider.courseIdController,
                                  hintText: "--Select Option--",
                                  height: 50,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    provider.selectedCourse =
                                        provider.courseNameController.text;
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () {
                                  provider.addQualification();
                                },
                              )
                            ],
                          ),

                          const SizedBox(height: 10),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.qualifications.length,
                            itemBuilder: (context, index) {

                              final q = provider.qualifications[index];

                              return Row(
                                children: [

                                  SizedBox(width: 40, child: Text("${index + 1}")),

                                  Expanded(child: Text(q.educationType)),

                                  Expanded(child: Text(q.course)),

                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      provider.removeQualification(index);
                                    },
                                  )
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: provider.descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),

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
                          onPressed: () {
                            if (validateAddJobForm(context, provider)) {
                              confirmAlertDialog(
                                context,
                                "Alert",
                                "Are you sure want to submit ?",
                                    (value) {
                                  if (value.toString() == "success") {
                                    provider.saveJobDetailApi(context);
                                  }
                                },
                              );
                            }
                          },
                          child: const Text("Post"),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 30)
                ],
              ),
                )
            );
          },
        ),
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
}

bool validateAddJobForm(BuildContext context, provider) {
  // ---------- EVENT ----------
  if (provider.eventIdController.text.trim().isEmpty) {
    showAlertError("Please select Event", context);
    return false;
  }

  // ---------- JOB SECTOR ----------
  if (provider.sectorIdController.text.trim().isEmpty) {
    showAlertError("Please select Sector", context);
    return false;
  }

  // ---------- JOB TTILE ----------
  if (provider.jobTitleIdController.text.trim().isEmpty) {
    showAlertError("Please select Title", context);
    return false;
  }

  // ---------- NCO ----------
  if (provider.ncoCodeIdController.text.trim().isEmpty) {
    showAlertError("Please select NCO Code", context);
    return false;
  }

  // ---------- Document ----------
  if (provider.uploadedDocumentPath == null ||
      provider.uploadedDocumentPath!.isEmpty) {
    showAlertError("Please Upload Document", context);
    return false;
  }

  // ---------- GENDER ----------
  if (provider.genderIdController.text.trim().isEmpty) {
    showAlertError("Please select Gender", context);
    return false;
  }

  // ---------- LOCATION ----------
  if (provider.locationIdController.text.trim().isEmpty) {
    showAlertError("Please select Location", context);
    return false;
  }

  // ---------- EMPLOYMENT TYPE ----------
  if (provider.empTypeIdController.text.trim().isEmpty) {
    showAlertError("Please select Employment Type", context);
    return false;
  }

  // ---------- NATURE OF JOB ----------
  if (provider.natureJobIdController.text.trim().isEmpty) {
    showAlertError("Please select Nature of Job", context);
    return false;
  }

  // ---------- WORK EXPERIENCE ----------
  if (provider.workExpIdController.text.trim().isEmpty) {
    showAlertError("Please select Work Experience", context);
    return false;
  }

  // ---------- SALARY RANGE ----------
  if (provider.salaryRangeIdController.text.trim().isEmpty) {
    showAlertError("Please select Salary Range", context);
    return false;
  }

  // ---------- SALARY ----------
  if (provider.salaryController.text.trim().isEmpty) {
    showAlertError("Please enter Salary", context);
    return false;
  }

  // ---------- CATEGORY ----------
  if (provider.categoryIdController.text.trim().isEmpty) {
    showAlertError("Please select Category", context);
    return false;
  }

  // ---------- SUBCATEGORY ----------
  if (provider.subCategoryIdController.text.trim().isEmpty) {
    showAlertError("Please select Subcategory", context);
    return false;
  }

  // ---------- EDUCATION TYPE ----------
  if (provider.educationIdController.text.trim().isEmpty) {
    showAlertError("Please select Education Type", context);
    return false;
  }

  // ---------- COURSE ----------
  if (provider.courseIdController.text.trim().isEmpty) {
    showAlertError("Please select Course", context);
    return false;
  }

  // ---------- Description ----------
  if (provider.descriptionController.text.trim().isEmpty) {
    showAlertError("Please enter Description", context);
    return false;
  }

  return true;
}
