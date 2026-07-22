import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/mysy/provider/join_log_provider.dart';

import '../../../constants/constants.dart';
import 'modal/mysy_list_model.dart';
import 'package:provider/provider.dart';

class JoinLogs extends StatelessWidget {
  final List<JoiningLog> data;

  const JoinLogs({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinLogProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Joining Logs"),
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
              //           "Registration No",
              //           item.regNo ?? "",
              //         ),
              //
              //         Padding(
              //           padding: const EdgeInsets.only(bottom: 8),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               const SizedBox(
              //                 width: 150,
              //                 child: Text(
              //                   "Joining Letter :",
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 icon: Icon(
              //                   Icons.remove_red_eye,
              //                   color: (item.lastLetter != null &&
              //                       item.lastLetter!.isNotEmpty)
              //                       ? Colors.blue
              //                       : Colors.grey,
              //                 ),
              //                 onPressed: (item.lastLetter != null &&
              //                     item.lastLetter!.isNotEmpty)
              //                     ? () {
              //                   provider.downloadAndOpenPdf(
              //                     Constants.showPdfUrl + item.lastLetter!,
              //                   );
              //                 }
              //                     : null,
              //               ),
              //             ],
              //           ),
              //         ),
              //
              //         _row(
              //           "Remarks",
              //           item.remarks ?? "",
              //         ),
              //         _row(
              //           "Status",
              //           item.currentStatus ?? "",
              //         ),
              //         _row(
              //           "Joining Date",
              //           item.joiningDate ?? "",
              //         ),
              //         _row(
              //           "Action Date",
              //           item.actionDate ?? "",
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
                      padding: const EdgeInsets.all(10),
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
                              Icons.login,
                              color: Color(0xff4F46E5),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Joining Log #${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Chip(
                            label: Text(
                              item.currentStatus ?? "N/A",
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
                            item.regNo ?? "",
                          ),

                          _row(
                            "Remarks",
                            item.remarks ?? "",
                          ),

                          _row(
                            "Status",
                            item.currentStatus ?? "",
                          ),

                          _row(
                            "Joining Date",
                            item.joiningDate ?? "",
                          ),

                          _row(
                            "Action Date",
                            item.actionDate ?? "",
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
                                  onPressed:
                                  (item.lastLetter != null &&
                                      item.lastLetter!
                                          .isNotEmpty)
                                      ? () {
                                    provider
                                        .downloadAndOpenPdf(
                                      Constants
                                          .showPdfUrl +
                                          item.lastLetter!,
                                    );
                                  }
                                      : null,
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