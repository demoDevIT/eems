import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/user_new.dart';
import 'modal/all_job_sector_list_modal.dart';
import 'provider/preferred_jobs_provider.dart';

class PreferredJobsScreen extends StatefulWidget {
  const PreferredJobsScreen({Key? key}) : super(key: key);

  @override
  State<PreferredJobsScreen> createState() => _PreferredJobsScreenState();
}

class _PreferredJobsScreenState extends State<PreferredJobsScreen> {
  //const PreferredJobsScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider =
      Provider.of<PreferredJobsProvider>(context, listen: false);

      await provider.getAllSectorListApi(context);

      /// Call search API on page load
      await provider.searchJobs(
        context
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferredJobsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: const Color(0xfff5f6fa),
            appBar: AppBar(
              title: const Text("Preferred Jobs"),
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// ===============================
                  /// 1️⃣ FILTER CARD
                  /// ===============================
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text("Filter",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),

                          const SizedBox(height: 16),

                          /// Job Title
                          _textField(
                            provider.jobTitleController,
                            "Search By Job Title",
                          ),

                          const SizedBox(height: 12),

                          /// Location
                          _textField(
                            provider.locationController,
                            "Search By Location",
                          ),

                          const SizedBox(height: 12),

                          /// Sector Dropdown
                          // DropdownButtonFormField<JobSectorData>(
                          //   value: provider.selectedSector,
                          //   decoration: _inputDecoration(),
                          //   hint: const Text("Select Sector"),
                          //   items: provider.jobSectorList
                          //       .map(
                          //         (e) => DropdownMenuItem(
                          //       value: e,
                          //       child: Text(e.sectorName ?? ""),
                          //     ),
                          //   )
                          //       .toList(),
                          //   onChanged: (value) {
                          //     provider.selectedSector = value;
                          //     provider.notifyListeners();
                          //   },
                          // ),

                          DropdownSearch<JobSectorData>(
                            items: (filter, infiniteScrollProps) => provider.jobSectorList,

                            selectedItem: provider.selectedSector,

                            itemAsString: (item) => item.sectorName ?? "",

                            compareFn: (item1, item2) =>
                            item1.id == item2.id, // 👈 IMPORTANT (use your unique field)

                            decoratorProps: DropDownDecoratorProps(
                              decoration: _inputDecoration(
                                hintText: "Select Sector",
                              ),
                            ),

                            popupProps: PopupProps.menu(
                              showSearchBox: true, // 🔥 search inside dropdown
                              fit: FlexFit.loose,
                              constraints: const BoxConstraints(maxHeight: 300),

                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: "Search Sector",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            onChanged: (value) {
                              provider.selectedSector = value;
                              provider.notifyListeners();
                            },
                          ),

                          const SizedBox(height: 16),

                          /// Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    provider.searchJobs(context); // pass logged in user id
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white, // 👈 This makes text white
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text("Search"),
                                ),
                              ),

                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    provider.clearFilters();
                                    await provider.searchJobs(context); // 🔥 reload data
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text("Clear"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ===============================
                  /// 2️⃣ JOB LIST CARD
                  /// ===============================
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// 🔹 Heading
                              const Text(
                                "Jobs based on your profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              /// 🔹 Apply Button (right side)
                              if (provider.selectedJobs.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    provider.showMultipleApplyConfirmation(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Apply (${provider.selectedJobs.length})",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// JOB LIST

                          ListView.builder(
                            itemCount: provider.jobList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final job = provider.jobList[index];

                              return InkWell(
                                onTap: () async {
                                  await provider.getJobDetailsByPostId(
                                    context,
                                    job.jobPostId ?? 0,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      /// ✅ CHECKBOX
                                      Checkbox(
                                        value: provider.selectedJobs.contains(job),
                                        onChanged: (value) {
                                          provider.toggleJobSelection(job);
                                        },
                                      ),

                                      const SizedBox(width: 8),

                                      /// Image
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.person, color: Colors.grey),
                                      ),

                                      const SizedBox(width: 12),

                                      /// Job Info (OLD UI RESTORED)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              job.jobTitle ?? "",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                            const SizedBox(height: 4),

                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                job.employementType ?? "",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Text(
                                              "Salary: ₹${job.salary ?? 0}",
                                              style: const TextStyle(fontSize: 13),
                                            ),

                                            const SizedBox(height: 6),

                                            Text(
                                              job.companyName ?? "",
                                              style: const TextStyle(fontSize: 13),
                                            ),

                                            const SizedBox(height: 4),

                                            Row(
                                              children: [
                                                const Icon(Icons.location_on,
                                                    size: 14,
                                                    color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text(
                                                  job.locations ?? "",
                                                  style: const TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 60),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );

  }

  /// =========================
  /// COMMON TEXTFIELD
  /// =========================

  Widget _textField(
      TextEditingController controller,
      String hint,
      ) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hintText: hint),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: kPrimaryColor),
      ),
    );
  }

}

class _SectorSearchSheet extends StatefulWidget {
  final List<JobSectorData> list;
  final JobSectorData? selected;

  const _SectorSearchSheet({
    required this.list,
    this.selected,
  });

  @override
  State<_SectorSearchSheet> createState() => _SectorSearchSheetState();
}

class _SectorSearchSheetState extends State<_SectorSearchSheet> {
  TextEditingController searchController = TextEditingController();
  List<JobSectorData> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.list;
  }

  void _filter(String query) {
    setState(() {
      filteredList = widget.list
          .where((e) =>
          (e.sectorName ?? "")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [

            /// 🔍 Search Field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search Sector",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filter,
            ),

            const SizedBox(height: 12),

            /// 📋 List
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  return ListTile(
                    title: Text(item.sectorName ?? ""),
                    trailing: widget.selected == item
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}