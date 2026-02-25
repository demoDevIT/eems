import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/mysy_list_provider.dart';

class MysyListScreen extends StatefulWidget {
  const MysyListScreen({super.key});

  @override
  State<MysyListScreen> createState() => _MysyListScreenState();
}

class _MysyListScreenState extends State<MysyListScreen> {

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<MysyListProvider>(context, listen: false)
          .getMysyListApi(context); // loggedInUserId
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MysyListProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: const Color(0xfff5f6fa),
          appBar: AppBar(
            title: const Text("MYSY List"),
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ===========================
                /// HEADING WITH COUNT
                /// ===========================
                Text(
                  "MYSY Application List (${provider.mysyList.length})",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// ===========================
                /// LIST VIEW
                /// ===========================
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.mysyList.length,
                    itemBuilder: (context, index) {
                      final item = provider.mysyList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            _row("Sr. No", (index + 1).toString()),
                            _row("Application No", item.applicationNo ?? ""),
                            _row("Father's Name", item.fatherName ?? ""),
                            _row("Scheme Name", item.schemeName ?? ""),
                            _row("Aadhar No", item.aadharNo ?? ""),
                            _row("Gender", item.gender ?? ""),
                            _row("Category", item.category ?? ""),
                            _row("DOB", item.dob ?? ""),
                            _row("Receiving Date", item.createdOn ?? ""),

                            const SizedBox(height: 8),

                            /// Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: item.schemeStatus == "Approved"
                                    ? Colors.green.shade100
                                    : item.schemeStatus == "Hold"
                                    ? Colors.orange.shade100
                                    : Colors.blue.shade100,
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.schemeStatus ?? "",
                                style: TextStyle(
                                  color: item.schemeStatus == "Approved"
                                      ? Colors.green
                                      : item.schemeStatus == "Hold"
                                      ? Colors.orange
                                      : Colors.blue,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),

                           // const SizedBox(height: 10),
                            //
                            // /// Action Button
                            // Align(
                            //   alignment:
                            //   Alignment.centerRight,
                            //   child: TextButton(
                            //     onPressed: () {
                            //       // later navigation
                            //     },
                            //     child:
                            //     const Text("View Details"),
                            //   ),
                            // )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
              const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
