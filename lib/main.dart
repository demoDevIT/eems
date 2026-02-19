import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rajemployment/role/counselor/counselor_dashboard/counselor_dashboard.dart';
import 'package:rajemployment/role/counselor/counselor_job_details/provider/counselor_job_details_provider.dart';
import 'package:rajemployment/role/counselor/counselor_jobs/provider/counselor_jobs_list_provider.dart';
import 'package:rajemployment/role/counselor/home/provider/counselor_provider.dart';
import 'package:rajemployment/role/counselor/otp/provider/otp_provider.dart';
import 'package:rajemployment/role/counselor/otp/screen/otp_screen.dart';
import 'package:rajemployment/role/counselor/registration/provider/registration_provider.dart';
import 'package:rajemployment/role/counselor/registration/screen/registration_screen.dart';
import 'package:rajemployment/role/department/dept_dashboard/provider/dept_dashboard_provider.dart';
import 'package:rajemployment/role/department/dept_join_attendance_list/provider/dept_join_attendance_list_provider.dart';
import 'package:rajemployment/role/department/dept_join_pending_list/provider/dept_join_pending_list_provider.dart';
import 'package:rajemployment/role/department/register_form/provider/register_form_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/branch_office_detail_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/contact_person_detail_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/emp_basic_detail_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/exchange_market_info_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/exchange_name_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/head_office_applicant_detail_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/head_office_detail_provider.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/uploaded_documents_provider.dart';
import 'package:rajemployment/role/employer/employerdashboard/employer_dashboard.dart';
import 'package:rajemployment/role/employer/empotr_form/provider/empotr_form_provider.dart';
import 'package:rajemployment/role/employer/sansthadhaarflowpage/provider/sansthadhaarflow_provider.dart';
import 'package:rajemployment/role/job_seeker/add_language_skills/provider/add_language_skills_provider.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/provider/add_educational_detail_provider.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/provider/add_job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/addphysicalattribute/provider/addphysicalattribute_provider.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/provider/address_info_provider.dart';
import 'package:rajemployment/role/job_seeker/addworkexperience/provider/add_work_experience_provider.dart';
import 'package:rajemployment/role/job_seeker/applied_jobs/provider/applied_jobs_provider.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/role/job_seeker/camera/provider/comera_provider.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/provider/cv_list_provider.dart';
import 'package:rajemployment/role/job_seeker/departmental_schemes/provider/mysy_pending_list_provider.dart';
import 'package:rajemployment/role/job_seeker/educationdetail/provider/education_details_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/add_grievance_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/homescreen/provider/home_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/janadhaarflowpage/janadhaarflowpage_screen.dart';
import 'package:rajemployment/role/job_seeker/janadhaarflowpage/provider/janadhaarflow_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/provider/job_details_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_apply_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_fair_event_details_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/jobs_fair_event_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/registered_event_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobseekerdashboard/job_seeker_dashboard.dart';
import 'package:rajemployment/role/job_seeker/languageandskill/provider/language_and_skill_provider.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/modal/login_modal.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/login_provider.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/screen/login_screen.dart';
import 'package:rajemployment/role/job_seeker/mysy/provider/mysy_list_provider.dart';
import 'package:rajemployment/role/job_seeker/otr_form/otr_form.dart';
import 'package:rajemployment/role/job_seeker/otr_form/provider/otr_form_provider.dart';
import 'package:rajemployment/role/job_seeker/physicalattribute/provider/physicalattribute_provider.dart';
import 'package:rajemployment/role/job_seeker/preferred_jobs/provider/preferred_jobs_provider.dart';
import 'package:rajemployment/role/job_seeker/profile/provider/profile_provider.dart';
import 'package:rajemployment/role/job_seeker/qr_scanner/provider/qr_scanner_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/registration_card/provider/registration_card_provider.dart';
import 'package:rajemployment/role/job_seeker/roleselectionscreen/provider/role_selection_provider.dart';
import 'package:rajemployment/role/job_seeker/select_company/provider/select_company_page_provider.dart';
import 'package:rajemployment/role/job_seeker/self_assessment/provider/self_assessment_provider.dart';
import 'package:rajemployment/role/job_seeker/share_feedback/provider/share_feedback_details_provider.dart';
import 'package:rajemployment/role/job_seeker/splachscreen/splash_screen.dart';
import 'package:rajemployment/role/job_seeker/videoprofile/provider/videoprofile_provider.dart';
import 'package:rajemployment/role/job_seeker/workexperience/provider/work_experience_provider.dart';
import 'package:rajemployment/role/notification/provider/notification_list_provider.dart';
import 'package:rajemployment/utils/app_shared_prefrence.dart';
import 'package:rajemployment/utils/images.dart';
import 'package:rajemployment/utils/right_to_left_route.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'l10n/app_localizations.dart';
import 'role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:firebase_core/firebase_core.dart';
// If you use FlutterFire CLI, also import:

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

  //  Firebase.initializeApp();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown, // optional: allow upside down
    ]);
    await di.init();

    final isTablet = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio >= 600;
    if (!isTablet) {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,
      ]);
    }
    // Launch App
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => di.sl<LocaleProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<LoginProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<CameraProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<VideoprofileProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JanAadhaarFlowProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<BasicDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddressInfoProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddEducationalDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddJobPreferenceProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddphysicalattributeProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddWorkExperienceProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<EducationDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<HomeScreenProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobPreferenceProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<PhysicalattributeProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<WorkExperienceProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<LanguageAndSkillProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<RoleSelectionProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<SelectCompanyPageProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobsListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<NotificationListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobsFairEventProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobFairEventDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<ShareFeedbackDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<RegistrationProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<OtpProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<CounselorProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<CounselorJobsListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<CounselorJobDetailsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddLanguageSkillsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AddGrievanceProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<GrievanceListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<RegisteredEventListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<JobApplyListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<MysyPendingListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<RegistrationCardProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<CvListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<OtrFormProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<QrScannerScreenProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<SansthaAadhaarFlowProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<EmpOTRFormProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<EmpBasicDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<BranchOfficeDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<HeadOfficeDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<HeadOfficeApplicantDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<ContactPersonDetailProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<ExchangeNameProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<ExchangeMarketInfoProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<UploadedDocumentsProvider>()),
         // ChangeNotifierProvider(create: (context) => di.sl<DepartmentDashboardProvider>())
          ChangeNotifierProvider(create: (context) => di.sl<RegisterFormProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<DeptJoinAttendanceListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<DeptJoinPendingListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<PreferredJobsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AppliedJobsProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<MysyListProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<SelfAssessmentProvider>()),
       ],
        child:MyApp(),
      ),
    );
  }, (error, stack) {
    // FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatelessWidget {


   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, localeProvider, child) {
      final locale = localeProvider.locale;
      // 👇 choose font based on language
      final textTheme = locale.languageCode == 'hi'
          ? GoogleFonts.notoSansDevanagariTextTheme(Theme.of(context).textTheme,
      ) : GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme,);

      return MaterialApp(
        navigatorKey: navigatorKey,
        locale: localeProvider.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        theme: ThemeData(colorScheme: const ColorScheme.light().copyWith(primary: kPrimaryDark,),textTheme:textTheme ),
        debugShowCheckedModeBanner: false,
        home:  MyHomePage(),
      );
    });
  }


}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );
  AppSharedPref sharedPref = AppSharedPref();
  var ids;
  bool? isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        getUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
            gradient: backgroundGradient,
          ),
          padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
          child: Image(
            image: AssetImage(Images.app_logo_title),
          ),
        ),
      ),
    );

  }

  getUserData() async {
    ids = await sharedPref.read('UserData');
    if (ids == '') {
      UserData().model.value.username = "";
      UserData().model.value.password = "";
      UserData().model.value.isLogin = false;
      setState(() {});
    } else {
      final usr = LoginData.fromJson(jsonDecode(jsonEncode(ids)));
      UserData().model.value.isLogin = true;
      UserData().model.value = usr;
    }

    if (UserData().model.value.isLogin == true) {
      /*Navigator.pushAndRemoveUntil<dynamic>(context,
          MaterialPageRoute<dynamic>(builder: (BuildContext context) => const OtpScreen()),
              (route) => false);*/

      if(UserData().model.value.roleId == 4){

        Navigator.pushAndRemoveUntil<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (BuildContext context) => const JobSeekerDashboard()),
                (route) => false);

      } else if(UserData().model.value.roleId == 7){

        Navigator.pushAndRemoveUntil<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (BuildContext context) => const EmployerDashboard()),
                (route) => false);

      }

     /* Navigator.of(context).push(
        RightToLeftRoute(
          page: const JobSeekerDashboard(),
          duration: const Duration(milliseconds: 500),
          startOffset: const Offset(-1.0, 0.0),
        ),
      );*/
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(context,
          MaterialPageRoute<dynamic>(builder: (BuildContext context) =>  LoginScreen()),
              (route) => false);
    }
  }
}
