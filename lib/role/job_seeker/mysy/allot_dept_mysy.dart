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

              // return Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(15),
              //     child: Column(
              //       children: [
              //         _row(
              //           "Department Name",
              //           item.deptName ?? "",
              //         ),
              //         _row(
              //           "Allocated Department Name",
              //           item.allotDeptName ?? "",
              //         ),
              //         _row(
              //           "Department Allocation Date",
              //           item.deptAllotDate ?? "",
              //         ),
              //         _row(
              //           "Joining Date",
              //           item.joiningDate ?? "",
              //         ),
              //
              //         Padding(
              //           padding:
              //           const EdgeInsets.only(bottom: 8),
              //           child: Row(
              //             crossAxisAlignment:
              //             CrossAxisAlignment.start,
              //             children: [
              //               const SizedBox(
              //                 width: 150,
              //                 child: Text(
              //                   "Joining Letter :",
              //                   style: TextStyle(
              //                     fontWeight:
              //                     FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 icon: const Icon(
              //                   Icons.remove_red_eye,
              //                   color: Colors.blue,
              //                 ),
              //                 onPressed: () {
              //                   if (item.joiningLetter !=
              //                       null &&
              //                       item.joiningLetter!
              //                           .isNotEmpty) {
              //                     provider
              //                         .downloadAndOpenPdf(
              //                       Constants.showPdfUrl +
              //                           item.joiningLetter!,
              //                     );
              //                   }
              //                 },
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    /// Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xff4F46E5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.business,
                              color: Color(0xff4F46E5),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              item.deptName ?? "Department",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [

                          _row(
                            "Department",
                            item.deptName ?? "",
                          ),

                          _row(
                            "Allocated To",
                            item.allotDeptName ?? "",
                          ),

                          _row(
                            "Allocation Date",
                            item.deptAllotDate ?? "",
                          ),

                          _row(
                            "Joining Date",
                            item.joiningDate ?? "",
                          ),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),

                                const SizedBox(width: 10),

                                const Expanded(
                                  child: Text(
                                    "Joining Letter",
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
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
                                  icon: const Icon(
                                    Icons.visibility,
                                  ),
                                  label: const Text(
                                    "View",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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