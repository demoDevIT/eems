import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/select_company/provider/select_company_page_provider.dart';
import 'package:rajemployment/role/job_seeker/select_company/modal/select_company_page_modal.dart';

class SelectCompanyPage extends StatefulWidget {
  const SelectCompanyPage({super.key});

  @override
  State<SelectCompanyPage> createState() => _SelectCompanyPageState();
}

class _SelectCompanyPageState extends State<SelectCompanyPage> {
  int? selectedJobSectorId;
  int? selectedJobTitleId;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<SelectCompanyPageProvider>(context, listen: false);

      selectedJobSectorId = null;
      selectedJobTitleId = null;

      provider.clearData();
      provider.getAllSectorListApi(context);

      provider.appliedJobMatchingListApi(
        context,
        jobSectorId: 0,
        jobTitleId: 0,
      );
    });
  }

  int _appliedCount(List<AppliedJobData> list) {
    return list.where((e) => e.isAlreadyApplied == 1).length;
  }

  /// ✅ CHECKBOX TAP HANDLER (FINAL)
  void _onCheckboxTap(AppliedJobData job) async {
    final provider =
    Provider.of<SelectCompanyPageProvider>(context, listen: false);

    final bool alreadyApplied = job.isAlreadyApplied == 1;

    // ✅ Count how many jobs are already applied
    final int appliedCount = provider.appliedJobList
        .where((e) => e.isAlreadyApplied == 1)
        .length;

    final int maxApply = job.maxApply ?? 0;

    // 🚫 BLOCK API CALL if max limit reached
    if (!alreadyApplied && appliedCount >= maxApply) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Alert"),
          content: const Text("You have applied max limit"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; // ⛔ STOP HERE
    }

    // 🔄 Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // 📡 API call
    final success = await provider.applyJobApi(
      context,
      job: job,
      apply: !alreadyApplied,
    );

    // ❌ Close loader
    Navigator.pop(context);

    // 📢 Show API message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message"),
        content: Text(provider.lastApiMessage ?? "Something went wrong"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    if (success) {
      provider.appliedJobMatchingListApi(
        context,
        jobSectorId: selectedJobSectorId ?? 0,
        jobTitleId: selectedJobTitleId ?? 0,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text(
          "Select Company",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<SelectCompanyPageProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              /// 🔽 DROPDOWNS
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _openSectorBottomSheet(provider),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Job Sector",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            selectedJobSectorId == null
                                ? "Select Job Sector"
                                : provider.jobSectorList
                                .firstWhere((e) => e.id == selectedJobSectorId)
                                .nameEng!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _openTitleBottomSheet(provider),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Job Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            selectedJobTitleId == null
                                ? "Select Job Title"
                                : provider.jobTitleList
                                .firstWhere((e) => e.id == selectedJobTitleId)
                                .nameEng!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Pick up to 5 companies.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),

              /// 🏢 JOB LIST
              Expanded(
                child: provider.appliedJobList.isEmpty
                    ? const Center(child: Text("No jobs found"))
                    : ListView.builder(
                  itemCount: provider.appliedJobList.length,
                  itemBuilder: (context, index) {
                    final job = provider.appliedJobList[index];
                    final bool isChecked =
                        job.isAlreadyApplied == 1;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: job.logo != null && job.logo!.isNotEmpty
                                      ? NetworkImage(job.logo!)
                                      : const AssetImage("assets/images/coffee.png") as ImageProvider,
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  job.jobtitle ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(job.companyName ?? ""),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(job.preLocation ?? ""),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Vacancy: ${job.totalVacancy ?? 0}",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  _onCheckboxTap(job),
                              child: Icon(
                                isChecked
                                    ? Icons.check_box
                                    : Icons
                                    .check_box_outline_blank,
                                color: isChecked
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔽 SECTOR SHEET
  void _openSectorBottomSheet(SelectCompanyPageProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.6;

        return SizedBox(
          height: height, // ✅ DOES NOT COVER FULL PAGE
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Select Job Sector",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.jobSectorList.length,
                  itemBuilder: (context, index) {
                    final item = provider.jobSectorList[index];
                    return ListTile(
                      title: Text(item.nameEng ?? ""),
                      onTap: () {
                        setState(() {
                          selectedJobSectorId = item.id;
                          selectedJobTitleId = null;
                        });
                        provider.jobTitleList.clear();
                        provider.appliedJobList.clear();
                        provider.notifyListeners();

                        provider.getAllTitleListApi(context, item.id!);

                        // ✅ CALL JOB LIST API WITH TITLE ID = 0
                        provider.appliedJobMatchingListApi(
                          context,
                          jobSectorId: item.id!,
                          jobTitleId: 0,
                        );

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openTitleBottomSheet(SelectCompanyPageProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.6;

        return SizedBox(
          height: height,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Select Job Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.jobTitleList.length,
                  itemBuilder: (context, index) {
                    final item = provider.jobTitleList[index];
                    return ListTile(
                      title: Text(item.nameEng ?? ""),
                      onTap: () {
                        setState(() {
                          selectedJobTitleId = item.id;
                        });

                        Navigator.pop(context);

                        // ✅ Call API with selected sector & title
                        if (selectedJobSectorId != null && selectedJobTitleId != null) {
                          provider.appliedJobMatchingListApi(
                            context,
                            jobSectorId: selectedJobSectorId!,
                            jobTitleId: selectedJobTitleId!,
                          );
                        }
                      },

                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
