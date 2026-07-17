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

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _row("Sr. No.", "${index + 1}"),
                      _row(
                        "Registration No",
                        item.regNo ?? "",
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 150,
                              child: Text(
                                "Joining Letter :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: (item.lastLetter != null &&
                                    item.lastLetter!.isNotEmpty)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: (item.lastLetter != null &&
                                  item.lastLetter!.isNotEmpty)
                                  ? () {
                                provider.downloadAndOpenPdf(
                                  Constants.showPdfUrl + item.lastLetter!,
                                );
                              }
                                  : null,
                            ),
                          ],
                        ),
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