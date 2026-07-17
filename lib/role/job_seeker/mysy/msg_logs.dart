import 'package:flutter/material.dart';

import 'modal/mysy_list_model.dart';

class MsgLogs extends StatelessWidget {
  final List<MessageLog> data;

  const MsgLogs({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Message Logs")),
      body: data.isEmpty
          ? const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ) : ListView.builder(
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
                    "Action Status",
                    item.applicationStatus ?? "",
                  ),
                  _row(
                    "Reason",
                    item.message ?? "",
                  ),
                  _row(
                    "Action Date",
                    item.sentOn ?? "",
                  ),
                ],
              ),
            ),
          );
        },
      ),
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