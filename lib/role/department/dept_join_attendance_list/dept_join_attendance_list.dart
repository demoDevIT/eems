import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/role/department/dept_join_attendance_list/modal/year_modal.dart';
import '../../../constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'modal/dept_join_attendance_modal.dart';
import 'modal/financial_year_modal.dart';
import 'modal/level_name_modal.dart';
import 'modal/month_modal.dart';
import 'provider/dept_join_attendance_list_provider.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/textstyles.dart';
import '../register_form/modal/district_modal.dart';


class DeptJoinAttendanceListScreen extends StatefulWidget {
  final String? registrationNumber;
  final String? jobSeekerId;
  final String? userId;

  const DeptJoinAttendanceListScreen({
    super.key,
    this.registrationNumber,
    this.jobSeekerId,
    this.userId,
  });



  @override
  State<DeptJoinAttendanceListScreen> createState() =>
      _DeptJoinAttendanceListScreenState();
}

class _DeptJoinAttendanceListScreenState
    extends State<DeptJoinAttendanceListScreen> {

  final ScrollController _listScrollController = ScrollController();

  bool _isFilterExpanded = true;

  Color _getRowColor(String? colorCode) {
    if (colorCode == null || colorCode.trim().isEmpty) {
      return Colors.white;
    }

    try {
      String hex = colorCode.trim().replaceFirst('#', '');

      // Add alpha channel if API gives #RRGGBB
      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();

    _listScrollController.addListener(_handleListScroll);

    /// 🔹 Call APIs after first frame
    Future.microtask(() async {
      final provider =
      Provider.of<DeptJoinAttendanceListProvider>(context, listen: false);

      provider.clearData();
      await provider.getYearApi(context);
      await provider.getMonthApi(context);

      provider.setCurrentYearMonth(); // 🔥 NEW

     // await provider.getDeptJoinAttendanceListApi(context);

      // provider.getDeptJoinAttendanceListApi(
      //   context,
      //   registrationNumber: widget.registrationNumber,
      //   jobSeekerId: widget.jobSeekerId,
      //   userId: widget.userId,
      //   page: 1,
      //   resetPage: true,
      // );

     // provider.regNoController.clear();

      provider.regNoController.text =
      (widget.registrationNumber?.isNotEmpty == true)
          ? widget.registrationNumber!
          : "";

      await provider.getDeptJoinAttendanceListApi(
        context,
        registrationNumber: widget.registrationNumber ?? "",
        jobSeekerId: widget.jobSeekerId ?? "",
        userId: null,
        page: 1,
        resetPage: true,
      );

    });
  }

  void _handleListScroll() {
    if (_isFilterExpanded &&
        _listScrollController.hasClients &&
        _listScrollController.position.userScrollDirection !=
            ScrollDirection.idle) {
      setState(() {
        _isFilterExpanded = false;
      });
    }
  }

  @override
  void dispose() {
    _listScrollController.removeListener(_handleListScroll);
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          //"Attendance List for Department Joining",
            AppLocalizations.of(context)!.internAttend,
          // "Pending Attendance list for Approval",
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
          if (provider.isPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              //  _filterSection(context, provider),

              // const SizedBox(height: 8),
              //
              // ElevatedButton(
              //   onPressed: provider.isAttendanceLoading
              //       ? null
              //       : () {
              //     provider.getDeptJoinAttendanceListApi(context);
              //   },
              //   child: const Text("Apply Filter"),
              // ),
              //
              // const SizedBox(height: 8),

              _filterCard(context, provider),

              /// 🔵 THIS IS MANDATORY
              Expanded(
                child: provider.isAttendanceLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.attendanceList.isEmpty
                    ? Center(
                    child: Text(AppLocalizations.of(context)!.noRecord))
                    : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _listScrollController,
                        //padding: const EdgeInsets.all(16),
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                        itemCount: provider.attendanceList.length,
                        itemBuilder: (context, index) {
                          final item = provider.attendanceList[index];
                          //return _pendingCard(context, provider, item);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: _getRowColor(item.rowColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _pendingCard(
                              context,
                              provider,
                              item,
                            ),
                          );

                        },
                      ),
                    ),

                    /// PAGINATION
                    if (provider.attendanceList.length > 10)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 10,
                      ),
                      child: _paginationControls(
                        context,
                        provider,
                      ),
                    ),
                  ],
                ),
              ),
            ],

          );
        }
      ),
    );
  }

  Widget _paginationControls(
      BuildContext context,
      DeptJoinAttendanceListProvider provider,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// PREVIOUS
          OutlinedButton.icon(
            onPressed: !provider.hasPreviousPage ||
                provider.isPaginationLoading
                ? null
                : () {
              provider.previousPage(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            label: const Text("Previous"),
          ),

          /// PAGE NUMBER
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Text(
              "Page ${provider.currentPage}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// NEXT
          ElevatedButton.icon(
            onPressed: !provider.hasNextPage ||
                provider.isPaginationLoading
                ? null
                : () {
              provider.nextPage(context);
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            label: const Text("Next"),
          ),
        ],
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
      color: _getRowColor(item.rowColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP SECTION (Photo + Basic Info)
            ///

            /// 🔹 TOP SECTION (Photo + Name + Registration No.)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Candidate Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.latestPhoto != null && item.latestPhoto!.isNotEmpty
                      ? Image.network(
                    Constants.showPdfUrl + item.latestPhoto!,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _placeholderImage();
                    },
                  )
                      : _placeholderImage(),
                ),

                const SizedBox(width: 14),

                /// Name + Registration No.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${AppLocalizations.of(context)!.regNo}${item.registrationNo ?? "-"}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${AppLocalizations.of(context)!.gender}"+": "+"${item.gender ?? "-"}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${AppLocalizations.of(context)!.dob}"+": "+"${item.dob ?? "-"}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //
            //     /// Candidate Image (Future Ready)
            //     // ClipRRect(
            //     //   borderRadius: BorderRadius.circular(8),
            //     //   child: (item.photo != null && item.photo!.isNotEmpty)
            //     //       ? Image.network(
            //     //     item.photo!, // 🔥 Change key later if needed
            //     //     height: 90,
            //     //     width: 90,
            //     //     fit: BoxFit.cover,
            //     //     errorBuilder: (context, error, stackTrace) {
            //     //       return _placeholderImage();
            //     //     },
            //     //   )
            //     //       : _placeholderImage(),
            //     // ),
            //     //
            //     // const SizedBox(width: 14),
            //
            //     /// Name + Mobile
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             item.name ?? "-",
            //             style: const TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           const SizedBox(height: 6),
            //           // RichText(
            //           //   text: TextSpan(
            //           //     style: const TextStyle(color: Colors.black87, fontSize: 16),
            //           //     children: [
            //           //       const TextSpan(
            //           //         text: "Mobile: ",
            //           //         style: TextStyle(fontWeight: FontWeight.bold),
            //           //       ),
            //           //       TextSpan(text: item.mobi ?? "-"),
            //           //     ],
            //           //   ),
            //           // ),
            //
            //           // RichText(
            //           //   text: TextSpan(
            //           //     style: const TextStyle(color: Colors.black87, fontSize: 16),
            //           //     children: [
            //           //       const TextSpan(
            //           //         text: "Department: ",
            //           //         style: TextStyle(fontWeight: FontWeight.bold),
            //           //       ),
            //           //       TextSpan(text: item.departmentNameEn ?? "-"),
            //           //     ],
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 15),

          //  _row(AppLocalizations.of(context)!.registrationNo, item.registrationNo),
            _row(AppLocalizations.of(context)!.fName, item.fName),
          //  _row(AppLocalizations.of(context)!.gender, item.gender),
            _row(AppLocalizations.of(context)!.category, item.category),
          //  _row(AppLocalizations.of(context)!.dob, item.dob),
            _row(AppLocalizations.of(context)!.approvalDate, _formatDate(item.approvalDate)),
            _row(AppLocalizations.of(context)!.joinDate, _formatDate(item.joinDate)),
            _row(AppLocalizations.of(context)!.eligibleDate, _formatDate(item.eligibleDate)),
            _fileRow(
              label: AppLocalizations.of(context)!.joinLetter,
              fileUrl: item.pdfPath,
              onTap: () {
                provider.downloadAndOpenPdf(item.pdfPath!);
              },
            ),
            _row(AppLocalizations.of(context)!.attendYear, item.year?.toString()),
            _row(AppLocalizations.of(context)!.attendMonth, item.monthName),
            _row(AppLocalizations.of(context)!.attendUploadOn, item.attendanceUploadedOn),
            _row(AppLocalizations.of(context)!.attendStatus, item.attendanceStatus),
            _fileRow(
              label: AppLocalizations.of(context)!.attendLetter,
              fileUrl: item.attendanceLetter,
              onTap: () {
                provider.downloadAndOpenPdf(item.attendanceLetter!);
              },
            ),

         //   const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                /// 🔹 VIEW TRAIL
                OutlinedButton(
                  onPressed: () {
                    // TODO: Add View Trail action
                  },
                  child: const Text("View Trail"),
                ),

                /// 🔹 SPACE
                if (item.enableMarkAttendance == 1)
                  const SizedBox(width: 8),

                /// 🔹 IF NOT MARKED
                if (item.enableMarkAttendance == 1)
                  OutlinedButton(
                    onPressed: () =>
                        provider.openAttendancePopup(context, item),
                    child: Text(AppLocalizations.of(context)!.markAttend),
                  ),

                /// 🔹 IF MARKED
                // if (item.attendanceStatus == 1) ...[
                //   OutlinedButton(
                //     onPressed: () {
                //       provider.viewCertificate(context, item);
                //     },
                //     child: const Text("View Certificate"),
                //   ),
                //   const SizedBox(width: 8),
                //   ElevatedButton(
                //     onPressed: () {
                //       provider.approveAttendance(context, item);
                //     },
                //     child: const Text("Approve"),
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 90,
      width: 90,
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.person,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";

    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.year.toString().padLeft(4, '0')}-"
          "${dateTime.month.toString().padLeft(2, '0')}-"
          "${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString.split("T").first; // fallback safe
    }
  }

  Widget _row(String label, String? value) {
    final String lowerLabel = label.toLowerCase();

    final bool isBoldValue =
        lowerLabel == "name" ||
            lowerLabel == "year" ||
            lowerLabel == "month";

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
              ).copyWith(
                fontWeight: FontWeight.bold, // Labels bold
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              style: Styles.regularTextStyle(
                size: 14,
                color: Colors.black87,
              ).copyWith(
                fontWeight:
                isBoldValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileRow({
    required String label,
    required String? fileUrl,
    required VoidCallback onTap,
  }) {
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
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          /// 🔹 VIEW BUTTON
          Expanded(
            child: fileUrl != null && fileUrl.isNotEmpty
                ? GestureDetector(
              onTap: onTap,
              child: Text(
                AppLocalizations.of(context)!.view,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : const Text("-"),
          ),
        ],
      ),
    );
  }

  Widget _filterCard(
      BuildContext context,
      DeptJoinAttendanceListProvider provider,
      ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F5), // light green/grey background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          /// TOP RIGHT - EXPAND / COLLAPSE
          /// FILTER HEADING + EXPAND / COLLAPSE
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 8, 3),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      _isFilterExpanded = !_isFilterExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: AnimatedRotation(
                      turns: _isFilterExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// FILTER BODY
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isFilterExpanded
                ? Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                10,
                10,
              ),
              child: Column(
                children: [
                  /// REGISTRATION NUMBER
                  TextField(
                    controller: provider.regNoController,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      labelText:
                      AppLocalizations.of(context)!
                          .registrationNo,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// YEAR + MONTH
                  Row(
                    children: [
                      /// YEAR
                      Expanded(
                        child:
                        DropdownButtonFormField<YearData>(
                          value: provider.selectedYearObj,
                          isDense: true,
                          decoration: InputDecoration(
                            labelText:
                            AppLocalizations.of(context)!
                                .year,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                Colors.grey.shade300,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          items: provider.yearListApi
                              .map((year) {
                            return DropdownMenuItem<
                                YearData>(
                              value: year,
                              child: Text(
                                year.name?.toString() ??
                                    "",
                                style:
                                const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            provider.selectedYearObj =
                                value;
                            provider.filterSelectedYear =
                                value?.dropID;

                            await provider
                                .search(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// MONTH
                      Expanded(
                        child:
                        DropdownButtonFormField<
                            MonthData>(
                          value:
                          provider.selectedMonthObj,
                          isDense: true,
                          decoration: InputDecoration(
                            labelText:
                            AppLocalizations.of(context)!
                                .month,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                Colors.grey.shade300,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          items: provider.monthListApi
                              .map((m) {
                            return DropdownMenuItem<
                                MonthData>(
                              value: m,
                              child: Text(
                                m.name ?? "",
                                style:
                                const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            provider.selectedMonthObj =
                                value;
                            provider
                                .filterSelectedMonthNumber =
                                value?.dropID;

                            await provider
                                .search(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// SEARCH + CLEAR
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            style:
                            ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    8),
                              ),
                            ),
                            onPressed: () {
                              provider.search(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .search,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            style:
                            OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              backgroundColor:
                              Colors.white,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    8),
                              ),
                            ),
                            onPressed: () {
                              provider.clearSearch();
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .clear,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// LEGEND
                  _buildAttendanceLegend(context),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLegend(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Row Information",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          _legendItem(
            color: Colors.green,
            text:
            "Highlighted rows indicate special cases whose attendance has been verified by the DEO",
          ),

          const SizedBox(height: 4),

          _legendItem(
            color: Colors.red,
            text:
            "Red rows indicate candidates who are over the maximum age limit",
          ),

          const SizedBox(height: 4),

          _legendItem(
            color: Colors.amber,
            text:
            "Yellow rows indicate candidates who have completed two years of internship",
          ),
        ],
      ),
    );
  }

  Widget _legendItem({
    required Color color,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              height: 1.25,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _filterCard(
  //     BuildContext context,
  //     DeptJoinAttendanceListProvider provider,
  //     ) {
  //   return Container(
  //     margin: const EdgeInsets.all(12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 6,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //
  //         /// 🔹 Registration No
  //         TextField(
  //           controller: provider.regNoController,
  //           decoration: InputDecoration(
  //             labelText: AppLocalizations.of(context)!.registrationNo,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 12),
  //
  //         /// 🔹 Year + Month Row
  //         Row(
  //           children: [
  //
  //             /// YEAR
  //             Expanded(
  //               child: DropdownButtonFormField<YearData>(
  //                 value: provider.selectedYearObj,
  //                 decoration: InputDecoration(
  //                   labelText: AppLocalizations.of(context)!.year,
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 items: provider.yearListApi.map((year) {
  //                   return DropdownMenuItem(
  //                     value: year,
  //                     child: Text(year.name?.toString() ?? ""),
  //                   );
  //                 }).toList(),
  //                 onChanged: (value) async {
  //                   provider.selectedYearObj = value;
  //                   provider.filterSelectedYear = value?.dropID;
  //
  //                   await provider.search(context);
  //                 },
  //               ),
  //             ),
  //
  //             const SizedBox(width: 10),
  //
  //             /// MONTH
  //             Expanded(
  //               child: DropdownButtonFormField<MonthData>(
  //                 value: provider.selectedMonthObj,
  //                 decoration: InputDecoration(
  //                   labelText: AppLocalizations.of(context)!.month,
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 items: provider.monthListApi
  //                     .map((m) => DropdownMenuItem(
  //                   value: m,
  //                   child: Text(m.name ?? ""),
  //                 ))
  //                     .toList(),
  //                 onChanged: (value) async {
  //                   provider.selectedMonthObj = value;
  //                   provider.filterSelectedMonthNumber = value?.dropID;
  //
  //                   await provider.search(context);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 12),
  //
  //         /// 🔹 Buttons
  //         Row(
  //           children: [
  //
  //             /// SEARCH
  //             Expanded(
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   provider.search(context);
  //                 },
  //                 child: Text(AppLocalizations.of(context)!.search),
  //               ),
  //             ),
  //
  //             const SizedBox(width: 10),
  //
  //             /// CLEAR
  //             Expanded(
  //               child: OutlinedButton(
  //                 onPressed: () {
  //                   provider.clearSearch();
  //                 },
  //                 child: Text(AppLocalizations.of(context)!.clear),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _getMonthName(int month) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[month - 1];
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

  // Widget _filterSection(
  //     BuildContext context,
  //     DeptJoinAttendanceListProvider provider,
  //     ) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     color: Colors.white,
  //     child: Column(
  //       children: [
  //
  //         /// LEVEL NAME
  //         DropdownButtonFormField<LevelData>(
  //           value: provider.selectedLevel,
  //           decoration: _inputDecoration("Select Level"),
  //           items: provider.levelList
  //               .map(
  //                 (e) => DropdownMenuItem(
  //               value: e,
  //               child: Text(e.levelNameEnglish ?? ""),
  //             ),
  //           )
  //               .toList(),
  //           onChanged: (value) {
  //             provider.selectedLevel = value;
  //             provider.notifyListeners();
  //
  //             if (value?.levelNameEnglish == "State") {
  //               provider.getDistrictApi(context, 1);
  //             }
  //           },
  //         ),
  //
  //
  //         const SizedBox(height: 10),
  //
  //         /// DISTRICT
  //         buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
  //           items: provider.districtList,
  //           controller: provider.districtController,
  //           idController: provider.districtIdController,
  //           hintText: "Select District",
  //           height: 50,
  //           selectedValue: provider.selectedDistrict,
  //           getLabel: (e) => e.name ?? "",
  //           onChanged: (value) {
  //             provider.selectedDistrict = value;
  //             provider.districtController.text = value?.name ?? "";
  //             provider.districtIdController.text =
  //                 value?.iD.toString() ?? "";
  //             provider.notifyListeners();
  //           },
  //         ),
  //
  //         const SizedBox(height: 10),
  //
  //         /// FINANCIAL YEAR (API later)
  //         DropdownButtonFormField<FinancialYearData>(
  //           value: provider.selectedFinancialYear,
  //           decoration: _inputDecoration("--Select Financial Year--"),
  //           items: provider.financialYearList
  //               .map(
  //                 (e) => DropdownMenuItem(
  //               value: e,
  //               child: Text(e.financialYearName ?? ""),
  //             ),
  //           )
  //               .toList(),
  //           onChanged: (value) {
  //             provider.selectedFinancialYear = value;
  //             provider.notifyListeners();
  //           },
  //         ),
  //
  //
  //
  //         const SizedBox(height: 10),
  //
  //         /// FROM DATE & END DATE
  //         Row(
  //           children: [
  //             Expanded(
  //               child: TextFormField(
  //                 controller: provider.fromDateController,
  //                 readOnly: true,
  //                 decoration: _inputDecoration("From Date").copyWith(
  //                   suffixIcon: const Icon(Icons.calendar_month),
  //                 ),
  //                 onTap: () => provider.pickFromDate(context),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: TextFormField(
  //                 controller: provider.endDateController,
  //                 readOnly: true,
  //                 decoration: _inputDecoration("End Date").copyWith(
  //                   suffixIcon: const Icon(Icons.calendar_month),
  //                 ),
  //                 onTap: () => provider.pickEndDate(context),
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //
  //       ],
  //     ),
  //   );
  // }

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

