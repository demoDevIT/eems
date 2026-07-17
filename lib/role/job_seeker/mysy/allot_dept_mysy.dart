import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/mysy/provider/allot_dept_provider.dart';
import '../../../constants/constants.dart';
import 'modal/mysy_list_model.dart';
import 'package:provider/provider.dart';

class AllotDeptMysy extends StatelessWidget {
  final List<AllottedDepartment> data;

  const AllotDeptMysy({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AllotDeptProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Allotted Department"),
          ),
          body: data.isEmpty
              ? const Center(
            child: Text(
              "No Data Found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (_, index) {
              final item = data[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _row(
                        "Department Name",
                        item.deptName ?? "",
                      ),
                      _row(
                        "Allocated Department Name",
                        item.allotDeptName ?? "",
                      ),
                      _row(
                        "Department Allocation Date",
                        item.deptAllotDate ?? "",
                      ),
                      _row(
                        "Joining Date",
                        item.joiningDate ?? "",
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 150,
                              child: Text(
                                "Joining Letter :",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                if (item.joiningLetter !=
                                    null &&
                                    item.joiningLetter!
                                        .isNotEmpty) {
                                  provider
                                      .downloadAndOpenPdf(
                                    Constants.showPdfUrl +
                                        item.joiningLetter!,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$title :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}