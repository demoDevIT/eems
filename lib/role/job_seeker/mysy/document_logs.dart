import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/mysy/provider/document_log_provider.dart';

import 'modal/mysy_list_model.dart';
import 'package:provider/provider.dart';

class DocumentLogs extends StatelessWidget {
  final List<DocumentLog> data;

  const DocumentLogs({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentLogProvider>(
        builder: (context, provider, child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Logs"),
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
          //         _row("Sr. No.", "${index + 1}"),
          //         _row(
          //           "RegistrationNo",
          //           item.RegNo ?? "",
          //         ),
          //         _row(
          //           "Document Name",
          //           item.DocName ?? "",
          //         ),
          //         _row(
          //           "View Document",
          //           item.ReveretDoc ?? "",
          //         ),
          //         _row(
          //           "Remarks",
          //           item.RevertMsg ?? "",
          //         ),
          //         _row(
          //           "Action By",
          //           item.actionBy ?? "",
          //         ),
          //         _row(
          //           "Action Date",
          //           item.revertedDate ?? "",
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
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xff4F46E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      // const CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //   child: Icon(
                      //     Icons.description,
                      //     color: Color(0xff4F46E5),
                      //   ),
                      // ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Document Log #${index + 1}",
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
                        "Registration No",
                        item.RegNo ?? "",
                      ),

                      _row(
                        "Document Name",
                        item.DocName ?? "",
                      ),

                      _row(
                        "Remarks",
                        item.RevertMsg ?? "",
                      ),

                      _row(
                        "Action By",
                        item.actionBy ?? "",
                      ),

                      _row(
                        "Action Date",
                        item.revertedDate ?? "",
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.insert_drive_file,
                              color: Colors.orange,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                item.ReveretDoc
                                    ?.toString() ??
                                    "No Document",
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Document Logs"),
  //     ),
  //     body: data.isEmpty
  //         ? const Center(
  //       child: Text("No Documents Found"),
  //     )
  //         : ListView.builder(
  //       itemCount: data.length,
  //       itemBuilder: (_, index) {
  //         return const Card(
  //           child: Padding(
  //             padding: EdgeInsets.all(15),
  //             child: Text("Document"),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _row(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 150,
  //           child: Text(
  //             "$title :",
  //             style: const TextStyle(
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(value),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}