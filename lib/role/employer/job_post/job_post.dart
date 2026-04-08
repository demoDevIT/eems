import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';

import '../../../utils/dropdown.dart';
import '../../job_seeker/addjobpreference/modal/sector_modal.dart';
import '../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import 'add_job.dart';
import 'provider/job_post_provider.dart';
import '../../../utils/textfeild.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {

  String? selectedEvent;
  String? selectedSector;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<JobPostProvider>(context, listen: false);
      provider.clearData();
      provider.getEventNameListApi(context);
      provider.sectorListApi(context);
      provider.getJobPostList(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: commonAppBar2("Post Job", context, "en", "", false, "", onTapClick: () {}),

      body: Consumer<JobPostProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Job Posts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Job"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddJobScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),

                /// FILTER CARD
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            labelWithStar('Event Name', required: false),

                            IgnorePointer(
                              ignoring: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                child: buildSearchableDropdown<EventNameData>(
                                  items: provider.eventNameList,

                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.dropID.toString(),
                                  getName: (item) => item.name ?? "",

                                  controller: provider.eventNameController,
                                  idController: provider.eventIdController,
                                  hintText: "--Select Option--",
                                  // height: 50,
                                  // color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEvent = provider.eventIdController.text;
                                    });
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 10),

                        /// SECTOR DROPDOWN
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            labelWithStar('Job Sector', required: false),

                            IgnorePointer(
                              ignoring: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                child: buildSearchableDropdown<SectorData>(
                                  items: provider.sectorList,

                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.dropID.toString(),
                                  getName: (item) => item.name ?? "",

                                  controller: provider.sectorNameController,
                                  idController: provider.sectorIdController,
                                  hintText: "--Select Option--",
                                  // height: 50,
                                  // color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSector = provider.sectorIdController.text;
                                    });
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 10),

                        /// SEARCH BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.filterJobs(
                                eventId: selectedEvent,
                                sectorId: selectedSector,
                              );
                            },
                            child: const Text("Search"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.jobPostList.length,
                    itemBuilder: (context, index) {

                      final data = provider.jobPostList[index];

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
                                      data.eventName, //data.title ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const Divider(),

                             // _buildRow("Event", data.eventName),
                              _buildRow("Sector", data.sectorName),
                              _buildRow("Title", data.jobPosition),
                              _buildRow("Qualification", data.qualification),
                              _buildRow("Skill", data.skillName),
                              _buildRow("Vacancy", getVacancyText(data)),
                              _buildRow("NCO", data.ncoCode),

                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Delete Job"),
                                          content: const Text("Are you sure you want to delete this job post?"),
                                          actions: [

                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),

                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);

                                                provider.deleteJobPost(
                                                  context,
                                                  data.jobPostId,
                                                );
                                              },
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                ),
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

  String getVacancyText(data) {
    List<String> vacancyList = [];

    if ((data.maleVacancy ?? 0) > 0) {
      vacancyList.add("Male - ${data.maleVacancy}");
    }

    if ((data.femaleVacancy ?? 0) > 0) {
      vacancyList.add("Female - ${data.femaleVacancy}");
    }

    if ((data.otherVacancy ?? 0) > 0) {
      vacancyList.add("Other - ${data.otherVacancy}");
    }

    if ((data.anyVacancy ?? 0) > 0) {
      vacancyList.add("Any - ${data.anyVacancy}");
    }

    return vacancyList.join(", ");
  }
}