
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/role/job_seeker/candidate_attendance/provider/candidate_attendance_provider.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/cv_list.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/user_new.dart';
import '../homescreen/home_screen.dart';
import '../loginscreen/screen/login_screen.dart';
import '../profile/profile.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import 'modal/event_model.dart';

class CandidateAttendanceScreen extends StatefulWidget {
  const CandidateAttendanceScreen({super.key});

  @override
  State<CandidateAttendanceScreen> createState() => _CandidateAttendanceScreenState();
}
enum AttendanceSearchType { none, registration, mobile }

class _CandidateAttendanceScreenState extends State<CandidateAttendanceScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CandidateAttendanceProvider>(
        context,
        listen: false,
      ).getEventList(context);
    });
  }


  int _currentIndex = 0;

  final FocusNode _regFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();


  final List<Widget> _pages = [
    HomeScreen(),
  ];


  /// 🔹 ADD FROM HERE
  AttendanceSearchType _searchType = AttendanceSearchType.none;

  final TextEditingController _regController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _showUserDetails = false;
  /// 🔹 ADD TILL HERE
  ///
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(
          context,
          "Are you sure you want to exit?",
              (value) => exitApp(context, value),
        );
        return false;
      },
      child: Scaffold(
        drawer: _buildSideDrawer(), // ✅ KEEP drawer

        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Row(
                  children: [
                    /// Scan QR
                    Expanded(
                      child: _actionButton(
                        title: "Scan QR",
                        isSelected: false,
                        backgroundColor: Colors.white, // ✅ white color
                        textColor: kViewAllColor,
                        onTap: () {
                          Navigator.of(context).push(
                            RightToLeftRoute(
                              page: const QRScannerScreen(),
                              duration: const Duration(milliseconds: 500),
                              startOffset: const Offset(-1.0, 0.0),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// Event Registration No
                    Expanded(
                      child: _actionButton(
                        title: "Event Reg. No.",
                        isSelected: _searchType == AttendanceSearchType.registration,
                        onTap: () {
                          _regFocusNode.unfocus();
                          _mobileFocusNode.unfocus();
                          setState(() {
                            _searchType = AttendanceSearchType.registration;
                            _showUserDetails = false;

                            // ✅ RESET INPUTS
                            _mobileController.clear();
                            _regController.clear();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// Mobile Number
                    Expanded(
                      child: _actionButton(
                        title: "Mobile No.",
                        isSelected: _searchType == AttendanceSearchType.mobile,
                        onTap: () {
                          _regFocusNode.unfocus();
                          _mobileFocusNode.unfocus();
                          setState(() {
                            _searchType = AttendanceSearchType.mobile;
                            _showUserDetails = false;

                            // ✅ RESET INPUTS
                            _regController.clear();
                            _mobileController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 20),

                if (_searchType != AttendanceSearchType.none) ...[
                  _eventDropdown(),
                  const SizedBox(height: 16),
                ],

                /// 🔹 Input Forms
                if (_searchType == AttendanceSearchType.registration)
                  _inputForm(
                    controller: _regController,
                    hint: "Event Registration Number",
                    focusNode: _regFocusNode,
                    onSubmit: _onSearchSubmit,
                  ),

                if (_searchType == AttendanceSearchType.mobile)
                  _inputForm(
                    controller: _mobileController,
                    hint: "Enter Mobile Number",
                    keyboardType: TextInputType.phone,
                    focusNode: _mobileFocusNode,
                    onSubmit: _onSearchSubmit,
                  ),

                const SizedBox(height: 20),

                // /// 🔹 User Details + Mark Attendance
                // if (_showUserDetails) _userDetailsCard(),
                // if (_showUserDetails) _jobAppliedList(),

                if (_showUserDetails) _userDetailsCard(),

                if (_showUserDetails) ...[
                  const SizedBox(height: 8),
                  _sectionHeader("Applied Jobs"),
                  _jobAppliedList(),
                ],

              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget _actionButton({
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isSelected ? kViewAllColor : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kViewAllColor),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor ??
                (isSelected ? Colors.white : kViewAllColor),
          ),
        ),
      ),
    );
  }

  Widget _eventDropdown() {
    return Consumer<CandidateAttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.eventList.isEmpty) return const SizedBox();

        return DropdownButtonFormField<EventModel>(
          value: provider.selectedEvent,
          isExpanded: true, // ⭐ VERY IMPORTANT
          hint: const Text(
            "Select Event",
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14, // ⭐ increases height
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: provider.eventList.map((event) {
            return DropdownMenuItem<EventModel>(
              value: event,
              child: Text(
                event.eventNameEng,
                maxLines: 1, // ⭐ prevent wrap
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            provider.selectedEvent = value;
            debugPrint("✅ Selected Event ID: ${value?.eventId}");
            provider.notifyListeners();
          },
        );
      },
    );
  }



  Widget _searchButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? kViewAllColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kViewAllColor),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : kViewAllColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _inputForm({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required VoidCallback onSubmit,
    FocusNode? focusNode,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text("Search"),
        ),
      ],
    );
  }

  void _onSearchSubmit() async {
    // ✅ REMOVE KEYBOARD FOCUS
    _regFocusNode.unfocus();
    _mobileFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    debugPrint("🟨 SUBMIT BUTTON CLICKED");

    if (_searchType == AttendanceSearchType.none) {
      showAlertError("Please select search type", context);
      return;
    }
    debugPrint("🟨 BEFORE PROVIDER");


    final provider =
    Provider.of<CandidateAttendanceProvider>(context, listen: false);
    debugPrint("🟨 AFTER PROVIDER");

    /// 2️⃣ ✅ NEW: Event validation
    if (provider.selectedEvent == null) {
      showAlertError("Please select Event", context);
      return;
    }

    if (_searchType == AttendanceSearchType.mobile) {
      if (_mobileController.text.isEmpty ||
          _mobileController.text.length != 10) {
        showAlertError("Please enter valid mobile number", context);
        return;
      }
    }

    if (_searchType == AttendanceSearchType.registration) {
      if (_regController.text.isEmpty) {
        showAlertError("Please enter registration number", context);
        return;
      }
    }

    // final provider =
    // Provider.of<CandidateAttendanceProvider>(context, listen: false);

    if (provider.selectedEvent == null) {
      showAlertError("Please select event", context);
      return;
    }

    debugPrint("🎯 Event ID Used: ${provider.selectedEvent!.eventId}");


    debugPrint("🟨 SEARCH TYPE: $_searchType");

    try {
      // ✅ SHOW LOADER
      ProgressDialog.showLoadingDialog(context);

      final success = await provider.getJobSeekerByRegOrMobile(
        context: context,
        eventId: provider.selectedEvent!.eventId, // ✅ FROM DROPDOWN
        mobileNo: _searchType == AttendanceSearchType.mobile
            ? _mobileController.text
            : '',
        eventRegNo: _searchType == AttendanceSearchType.registration
            ? _regController.text
            : '',
      );


      ProgressDialog.closeLoadingDialog(context);

      if (success) {
        setState(() => _showUserDetails = true);
      } else {
        setState(() => _showUserDetails = false); // 🔴 REQUIRED
        showAlertError("No data found", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError("Something went wrong", context);
    }
  }



  Widget _userDetailsCard() {
    final provider = Provider.of<CandidateAttendanceProvider>(context);

    final user = provider.jobSeeker!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow("Name", user.jobSeekerName),
            _detailRow("Registration Date", user.registrationDate),
            _detailRow("Highest Qualification", user.higQualification),
            _detailRow("Mobile Number", user.mobileNo),
            _detailRow("Event Reg. No.", user.registrationNo),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                final provider =
                Provider.of<CandidateAttendanceProvider>(context, listen: false);

                if (provider.selectedEvent == null) {
                  showAlertError("Please select event", context);
                  return;
                }

                provider.markAttendance(
                  context,
                  eventId: provider.selectedEvent!.eventId, // ✅ DROPDOWN VALUE
                );
              },

              child: const Text("Mark Attendance"),
            )
          ],
        ),
      ),
    );
  }


  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value),
        ],
      ),
    );
  }

  Widget _jobAppliedList() {
    final provider = Provider.of<CandidateAttendanceProvider>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.jobPreferences.length,
      itemBuilder: (context, index) {
        final job = provider.jobPreferences[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _jobRow("Job Title", job.title),
                _jobRow("Sector", job.sector),
                _jobRow("Company", job.company),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _jobRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90, // fixed width for label
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }


  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            height: 1,
            width: 60,
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }


  /// Side Drawer
  /// Side Drawer
  Drawer _buildSideDrawer() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding:
            const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile avatar + progress
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Transform.rotate(
                            angle: 2.00,
                            child: SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: 0.7, // 70%
                                strokeWidth: 7,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(kViewAllColor),
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Image.network(
                              UserData().model.value.latestPhotoPath.toString(),
                              width: MediaQuery.of(context).size.width * 0.18,
                              height: MediaQuery.of(context).size.width * 0.18,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Images.placeholder,
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  height: MediaQuery.of(context).size.width * 0.18,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          // ✅ Moved and adjusted this Positioned widget
                          Positioned(
                            right: -10, // half outside
                            top: 5, // vertically centered on right side
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: FFF2EDColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "70%",
                                style: TextStyle(
                                  color: kDarkOrangeColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width :MediaQuery.of(context).size.width * 0.20,
                            child:  Text(
                              "Demo User",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) =>  ProfileScreen(isAppBarHide: true,)),
                          //     );
                          //   },
                          //   child: Text(
                          //     AppLocalizations.of(context)!.updateprofile,
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       //color: Colors.blue,
                          //       color: kViewAllColor,
                          //       fontWeight: FontWeight.w600,
                          //       decoration: TextDecoration.none,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Close button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/icons/close.svg',
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset('assets/icons/home.svg',color: grayLightColor,
                width: 20, height: 20),
            title: Text(AppLocalizations.of(context)!.dashboard,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 0);
              Navigator.pop(context);
            },
          ),

          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.logout,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              showLogoutDialog(context, "Logout","Are you sure want to Logout ?", "Thank you and see you again!", (value) {
                if (value.toString() == "success") {
                  final pref = AppSharedPref();
                  pref.save('UserData', '');
                  pref.remove('UserData');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const LoginScreen(),
                    ),
                  );
                }
              },
              );
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
        ],
      ),
    );
  }
}

