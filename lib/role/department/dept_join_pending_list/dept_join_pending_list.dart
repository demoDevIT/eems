import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/role/department/dept_join_pending_list/provider/dept_join_pending_list_provider.dart';
import 'modal/dept_join_pending_modal.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/textstyles.dart';

class DeptJoinPendingListScreen extends StatelessWidget {
  const DeptJoinPendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          "Pending List for Department Joining",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DeptJoinPendingListProvider>(
        builder: (context, provider, _) {
          if (provider.pendingList.isEmpty) {
            return const Center(child: Text("No pending records"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.pendingList.length,
            itemBuilder: (context, index) {
              final item = provider.pendingList[index];
              return _pendingCard(context, provider, item);
            },
          );
        },
      ),
    );
  }

  Widget _pendingCard(
      BuildContext context,
      DeptJoinPendingListProvider provider,
      DeptJoinPendingItem item,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _row("Name", item.name),
            _row("Father Name", item.fatherName),
            _row("Date of Allotment", item.allotmentDate),
            _row("Exchange Name", item.exchangeName),

            // const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ElevatedButton(
                //   onPressed: () =>
                //       provider.onApproveJoining(context, item),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: const Text("Approve Joining"),
                // ),
                OutlinedButton(
                  onPressed: () =>
                      provider.onApproveJoining(context, item),
                  child: const Text("Approve Joining"), //first this button will show only, when click on this button then next 2 buttons will show and this button will be hide
                ),

                OutlinedButton(
                  onPressed: () =>
                      provider.onViewJoiningLetter(context, item),
                  child: const Text("View Joining Letter"),
                ),

                // OutlinedButton(
                //   onPressed: () =>
                //       provider.onViewJoiningLetter(context, item),
                //   child: const Text("E-sign"),
                // ),

                // 2 buttons conditionally, not 3 always***************
                // IconButton(
                //   onPressed: () =>
                //       provider.onESign(context, item),
                //   icon: const Icon(Icons.edit_document),
                //   color: Colors.blue,
                //   tooltip: "E-Sign",
                // ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: Styles.mediumTextStyle(
                size: 14,
                color: kBlackColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Styles.regularTextStyle(
                size: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _iconBtn({
  //   required IconData icon,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return IconButton(
  //     icon: Icon(icon, color: color),
  //     onPressed: onTap,
  //   );
  // }
}
