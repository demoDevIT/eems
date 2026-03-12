import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/textfeild.dart';
import 'provider/add_job_provider.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
 // const AddJobScreen({super.key});

  String? selectedEvent;
  String? selectedSector;
  String? selectedjobTitle;
  String? selectedNcoCode;
  String? selectedgender;
  String? selectedLocation;
  String? selectedEmpType;
  String? selectedNatureJob;
  String? selectedSalaryRange;

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
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [

                              labelWithStar('Job Description', required: false),

                              OutlinedButton.icon(
                                icon: const Icon(Icons.attach_file),
                                label: const Text("Attach File"),
                                onPressed: () {
                                  //provider.pickJobDescriptionFile();
                                },
                              )
                            ],
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.locationList,
                              controller: provider.locationController,
                              idController: provider.locationIdController,
                              hintText: "--Select Option--",
                              height: 50,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                selectedLocation = provider.locationIdController.text;
                                provider.notifyListeners();
                              },
                            ),
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
                          const Text("Work Experience",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 5),
                          DropdownButtonFormField(
                            hint: const Text("Work Experience"),
                            items: provider.experiences
                                .map((e) => DropdownMenuItem(
                                value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) {
                              provider.workExperience = v.toString();
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
                              provider.getSubCategoryTypeDetailsApi(
                                context,
                                provider.categoryIdController.text,
                              );
                            },
                          ),
                          const SizedBox(height: 10),

                          /// SUBCATEGORY + ADD BUTTON

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
                                  onChanged: (value) {},
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

                          DropdownButtonFormField(
                            hint: const Text("Education"),
                            items: provider.educationTypes
                                .map((e) => DropdownMenuItem(
                                value: e, child: Text(e)))
                                .toList(),
                            value: provider.selectedEducationType,
                            onChanged: (v) {
                              provider.selectedEducationType = v.toString();
                            },
                          ),
                          const SizedBox(height: 10),


                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  hint: const Text("Course"),
                                  items: provider.courses
                                      .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                      .toList(),
                                  value: provider.selectedCourse,
                                  onChanged: (v) {
                                    provider.selectedCourse = v.toString();
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
                            //provider.submitJob(context);
                          },
                          child: const Text("Post"),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 30)
                ],
              ),
            );
          },
        ),
      );

  }
}