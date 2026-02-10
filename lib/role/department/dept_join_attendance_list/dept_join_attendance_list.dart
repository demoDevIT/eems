import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modal/dept_join_attendance_modal.dart';
import 'modal/financial_year_modal.dart';
import 'modal/level_name_modal.dart';
import 'provider/dept_join_attendance_list_provider.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/textstyles.dart';
import '../register_form/modal/district_modal.dart';


class DeptJoinAttendanceListScreen extends StatefulWidget {
  const DeptJoinAttendanceListScreen({super.key});

  @override
  State<DeptJoinAttendanceListScreen> createState() =>
      _DeptJoinAttendanceListScreenState();
}

class _DeptJoinAttendanceListScreenState
    extends State<DeptJoinAttendanceListScreen> {

  @override
  void initState() {
    super.initState();

    /// 🔹 Call APIs after first frame
    Future.microtask(() {
      final provider =
      Provider.of<DeptJoinAttendanceListProvider>(context, listen: false);

      provider.clearData();

      provider.getLevelApi(context);
      provider.getFinancialYearApi(context);
      provider.getDistrictApi(context, 1); // default stateId
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          "Attendance List for Department Joining",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DeptJoinAttendanceListProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              _filterSection(context, provider),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: provider.isAttendanceLoading
                    ? null
                    : () {
                  provider.getDeptJoinAttendanceListApi(context);
                },
                child: const Text("Apply Filter"),
              ),

              const SizedBox(height: 8),

              /// 🔵 THIS IS MANDATORY
              Expanded(
                child: provider.isAttendanceLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.attendanceList.isEmpty
                    ? const Center(child: Text("No records found"))
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.attendanceList.length,
                  itemBuilder: (context, index) {
                    final item = provider.attendanceList[index];
                    return _pendingCard(context, provider, item);
                  },
                ),
              ),
            ],
          );
        },
      ),


    );
  }

  Widget _pendingCard(
      BuildContext context,
      DeptJoinAttendanceListProvider provider,
      DeptJoinAttendanceItem item,
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

            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton.icon(
                //   onPressed: () =>
                //       provider.pickAttendanceDate(context, item),
                //   icon: const Icon(Icons.calendar_month),
                //   label: const Text("Mark Attendance"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),

                OutlinedButton(
                  onPressed: () =>
                      provider.pickAttendanceDate(context, item),
                  child: const Text("Mark Attendance"),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
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
              value?.isNotEmpty == true ? value! : "-",
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

  Widget _filterSection(
      BuildContext context,
      DeptJoinAttendanceListProvider provider,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [

          /// LEVEL NAME
          provider.isLevelLoading
              ? const CircularProgressIndicator()
              : DropdownButtonFormField<LevelData>(
            value: provider.selectedLevel,
            decoration: _inputDecoration("Select Level"),
            items: provider.levelList
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e.levelNameEnglish ?? ""),
              ),
            )
                .toList(),
            onChanged: (value) {
              provider.selectedLevel = value;
              provider.notifyListeners();

              if (value?.levelNameEnglish == "State") {
                provider.getDistrictApi(context, 1);
              }
            },
          ),


          const SizedBox(height: 10),

          /// DISTRICT
          provider.isDistrictLoading
              ? const CircularProgressIndicator()
              : buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
            items: provider.districtList,
            controller: provider.districtController,
            idController: provider.districtIdController,
            hintText: "Select District",
            height: 50,
            selectedValue: provider.selectedDistrict,
            getLabel: (e) => e.name ?? "",
            onChanged: (value) {
              provider.selectedDistrict = value;
              provider.districtController.text = value?.name ?? "";
              provider.districtIdController.text =
                  value?.iD.toString() ?? "";
              provider.notifyListeners();
            },
          ),

          const SizedBox(height: 10),

          /// FINANCIAL YEAR (API later)
          provider.isFinancialYearLoading
              ? const CircularProgressIndicator()
              : DropdownButtonFormField<FinancialYearData>(
            value: provider.selectedFinancialYear,
            decoration: _inputDecoration("--Select Financial Year--"),
            items: provider.financialYearList
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e.financialYearName ?? ""),
              ),
            )
                .toList(),
            onChanged: (value) {
              provider.selectedFinancialYear = value;
              provider.notifyListeners();
            },
          ),



          const SizedBox(height: 10),

          /// FROM DATE & END DATE
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: provider.fromDateController,
                  readOnly: true,
                  decoration: _inputDecoration("From Date").copyWith(
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  onTap: () => provider.pickFromDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: provider.endDateController,
                  readOnly: true,
                  decoration: _inputDecoration("End Date").copyWith(
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  onTap: () => provider.pickEndDate(context),
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }

}

Widget buildDropdownWithBorderFieldOnlyThisPage<T>({
  required List<T> items,
  required TextEditingController controller,
  required TextEditingController idController,
  required String hintText,
  required double height,
  required T? selectedValue,
  required ValueChanged<T?>? onChanged, // 👈 nullable
  String Function(T)? getLabel,
}) {
  return SizedBox(
    height: height,
    child: InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: fafafaColor,
        // SAME as text field
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel != null ? getLabel(item) : item.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blue),
    ),
  );
}

