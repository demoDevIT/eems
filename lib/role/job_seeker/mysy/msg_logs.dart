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

          // return Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15),
          //     child: Column(
          //       children: [
          //         _row("Sr. No.", "${index + 1}"),
          //         _row(
          //           "Action Status",
          //           item.applicationStatus ?? "",
          //         ),
          //         _row(
          //           "Reason",
          //           item.message ?? "",
          //         ),
          //         _row(
          //           "Action Date",
          //           item.sentOn ?? "",
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
                  padding: const EdgeInsets.all(11),
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
                          Icons.message,
                          color: Color(0xff4F46E5),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Message Log #${index + 1}",
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

                      const SizedBox(height: 10),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Chip(
                      //     avatar: const Icon(
                      //       Icons.access_time,
                      //       size: 18,
                      //     ),
                      //     label: Text(
                      //       item.sentOn ?? "",
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
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