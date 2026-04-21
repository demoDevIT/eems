
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
        //drawer: _buildSideDrawer(), // ✅ KEEP drawer
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text(
            "Attendance",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          //iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Row(
                  children: [
                    /// Scan QR
                    // Expanded(
                    //   child: _actionButton(
                    //     title: "Scan QR",
                    //     isSelected: false,
                    //     backgroundColor: Colors.white, // ✅ white color
                    //     textColor: kViewAllColor,
                    //     onTap: () {
                    //       Navigator.of(context).push(
                    //         RightToLeftRoute(
                    //           page: const QRScannerScreen(),
                    //           duration: const Duration(milliseconds: 500),
                    //           startOffset: const Offset(-1.0, 0.0),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(width: 8),

                    /// Event Registration No
                    Expanded(
                      child: _toggleButton(
                        title: "#  Event Reg. No.",
                        isSelected: _searchType == AttendanceSearchType.registration,
                        onTap: () {
                          _regFocusNode.unfocus();
                          _mobileFocusNode.unfocus();
                          setState(() {
                            _searchType = AttendanceSearchType.registration;
                            _showUserDetails = false;
                            _mobileController.clear();
                            _regController.clear();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _toggleButton(
                        title: "Mobile No.",
                        icon: "assets/icons/mobIcon.svg",
                        isSelected: _searchType == AttendanceSearchType.mobile,
                        onTap: () {
                          _regFocusNode.unfocus();
                          _mobileFocusNode.unfocus();
                          setState(() {
                            _searchType = AttendanceSearchType.mobile;
                            _showUserDetails = false;
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

  Widget _toggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    String? icon, // ✅ NEW
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? kViewAllColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon,
                height: 16,
                width: 16,
                color: isSelected ? Colors.white : Colors.black54, // ✅ dynamic color
              ),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ],
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
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: kViewAllColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kViewAllColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onSubmit,
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text("Search"),
          ),
        )
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

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ FIXED
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: kViewAllColor,
                child: Text(
                  user.jobSeekerName[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.jobSeekerName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text("Registered Attendee",
                      style: TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),

          _infoTile("assets/icons/reggg.svg", "Registration Date", user.registrationDate),
          _divider(),
          _infoTile("assets/icons/graduatIcon.svg", "Highest Qualification", user.higQualification),
          _divider(),
          _infoTile("assets/icons/callIcon.svg", "Mobile Number", user.mobileNo),
          _divider(),
          _infoTile("assets/icons/eventRegIcon.svg", "Event Reg. No.", user.registrationNo),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kViewAllColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final provider =
                Provider.of<CandidateAttendanceProvider>(context, listen: false);

                if (provider.selectedEvent == null) {
                  showAlertError("Please select event", context);
                  return;
                }

                provider.markAttendance(
                  context,
                  eventId: provider.selectedEvent!.eventId,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Mark Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoTile(String iconPath, String title, String value) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          height: 18,
          width: 18,
          color: kViewAllColor, // same blue color as UI
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: Colors.grey),
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
            onTap: () async {
              Navigator.pop(context); // Close the drawer
              showLogoutDialog(context, "Logout","Are you sure want to Logout ?", "Thank you and see you again!", (value) async {
                if (value.toString() == "success") {
                  final pref = AppSharedPref();
                  // Clear login session only
                  UserData().model.value.isLogin = false;
                  UserData().model.value.userId = null;
                  await pref.remove('UserData');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //     const LoginScreen(),
                  //   ),
                  // );
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

