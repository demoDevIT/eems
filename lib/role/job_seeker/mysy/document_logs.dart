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

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _row("Sr. No.", "${index + 1}"),
                  _row(
                    "RegistrationNo",
                    item.RegNo ?? "",
                  ),
                  _row(
                    "Document Name",
                    item.DocName ?? "",
                  ),
                  _row(
                    "View Document",
                    item.ReveretDoc ?? "",
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