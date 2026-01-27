import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rajemployment/repo/common_repo.dart';
import 'package:rajemployment/role/counselor/counselor_job_details/provider/counselor_job_details_provider.dart';
import 'package:rajemployment/role/counselor/counselor_jobs/provider/counselor_jobs_list_provider.dart';
import 'package:rajemployment/role/counselor/home/provider/counselor_provider.dart';
import 'package:rajemployment/role/counselor/otp/provider/otp_provider.dart';
import 'package:rajemployment/role/counselor/registration/provider/registration_provider.dart';
import 'package:rajemployment/role/employer/empotr_form/provider/empotr_form_provider.dart';
import 'package:rajemployment/role/employer/sansthadhaarflowpage/provider/sansthadhaarflow_provider.dart';
import 'package:rajemployment/role/job_seeker/add_language_skills/provider/add_language_skills_provider.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/provider/add_educational_detail_provider.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/provider/add_job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/addphysicalattribute/provider/addphysicalattribute_provider.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/provider/address_info_provider.dart';
import 'package:rajemployment/role/job_seeker/addworkexperience/provider/add_work_experience_provider.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart' show BasicDetailsProvider;
import 'package:rajemployment/role/job_seeker/camera/provider/comera_provider.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/provider/cv_list_provider.dart';
import 'package:rajemployment/role/job_seeker/departmental_schemes/provider/mysy_pending_list_provider.dart';
import 'package:rajemployment/role/job_seeker/educationdetail/provider/education_details_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/add_grievance_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/homescreen/provider/home_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/janadhaarflowpage/provider/janadhaarflow_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/provider/job_details_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_apply_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_fair_event_details_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/jobs_fair_event_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/registered_event_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/role/job_seeker/languageandskill/provider/language_and_skill_provider.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/login_provider.dart';
import 'package:rajemployment/role/job_seeker/otr_form/provider/otr_form_provider.dart';
import 'package:rajemployment/role/job_seeker/physicalattribute/provider/physicalattribute_provider.dart';
import 'package:rajemployment/role/job_seeker/profile/provider/profile_provider.dart';
import 'package:rajemployment/role/job_seeker/qr_scanner/provider/qr_scanner_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/registration_card/provider/registration_card_provider.dart';
import 'package:rajemployment/role/job_seeker/roleselectionscreen/provider/role_selection_provider.dart';
import 'package:rajemployment/role/job_seeker/select_company/provider/select_company_page_provider.dart';
import 'package:rajemployment/role/job_seeker/share_feedback/provider/share_feedback_details_provider.dart';
import 'package:rajemployment/role/job_seeker/videoprofile/provider/videoprofile_provider.dart';
import 'package:rajemployment/role/job_seeker/workexperience/provider/work_experience_provider.dart';
import 'package:rajemployment/role/notification/provider/notification_list_provider.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service/datasource/remote/dio/dio_client.dart';
import 'api_service/datasource/remote/dio/logging_interceptor.dart';
import 'constants/constants.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Core url
  sl.registerLazySingleton(() => DioClient(Constants.baseurl,"", sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());




  //Repo
  sl.registerLazySingleton(() => CommonRepo(dioClient: sl(),));


  //Provider
  sl.registerFactory(() => LocaleProvider(commonRepo: sl()));
  sl.registerFactory(() => LoginProvider(commonRepo: sl()));
  sl.registerFactory(() => CameraProvider(commonRepo: sl()));
  sl.registerFactory(() => VideoprofileProvider(commonRepo: sl()));
  sl.registerFactory(() => JanAadhaarFlowProvider(commonRepo: sl()));
  sl.registerFactory(() => BasicDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => AddressInfoProvider(commonRepo: sl()));
  sl.registerFactory(() => AddEducationalDetailProvider(commonRepo: sl()));
  sl.registerFactory(() => AddJobPreferenceProvider(commonRepo: sl()));
  sl.registerFactory(() => AddphysicalattributeProvider(commonRepo: sl()));
  sl.registerFactory(() => AddWorkExperienceProvider(commonRepo: sl()));
  sl.registerFactory(() => EducationDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => HomeScreenProvider(commonRepo: sl()));
  sl.registerFactory(() => JobPreferenceProvider(commonRepo: sl()));
  sl.registerFactory(() => PhysicalattributeProvider(commonRepo: sl()));
  sl.registerFactory(() => WorkExperienceProvider(commonRepo: sl()));
  sl.registerFactory(() => LanguageAndSkillProvider(commonRepo: sl()));
  sl.registerFactory(() => ProfileProvider(commonRepo: sl()));
  sl.registerFactory(() => RoleSelectionProvider(commonRepo: sl()));
  sl.registerFactory(() => SelectCompanyPageProvider(commonRepo: sl()));
  sl.registerFactory(() => JobsListProvider(commonRepo: sl()));
  sl.registerFactory(() => JobDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => NotificationListProvider(commonRepo: sl()));
  sl.registerFactory(() => JobsFairEventProvider(commonRepo: sl()));
  sl.registerFactory(() => JobFairEventDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => ShareFeedbackDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => RegistrationProvider(commonRepo: sl()));
  sl.registerFactory(() => OtpProvider(commonRepo: sl()));
  sl.registerFactory(() => CounselorProvider(commonRepo: sl()));
  sl.registerFactory(() => CounselorJobsListProvider(commonRepo: sl()));
  sl.registerFactory(() => CounselorJobDetailsProvider(commonRepo: sl()));
  sl.registerFactory(() => AddLanguageSkillsProvider(commonRepo: sl()));
  sl.registerFactory(() => AddGrievanceProvider(commonRepo: sl()));
  sl.registerFactory(() => GrievanceListProvider(commonRepo: sl()));
  sl.registerFactory(() => RegisteredEventListProvider(commonRepo: sl()));
  sl.registerFactory(() => JobApplyListProvider(commonRepo: sl()));
  sl.registerFactory(() => MysyPendingListProvider(commonRepo: sl()));
  sl.registerFactory(() => RegistrationCardProvider(commonRepo: sl()));
  sl.registerFactory(() => CvListProvider(commonRepo: sl()));
  sl.registerFactory(() => OtrFormProvider(commonRepo: sl()));
  sl.registerFactory(() => QrScannerScreenProvider(commonRepo: sl()));
  sl.registerFactory(() => SansthaAadhaarFlowProvider(commonRepo: sl()));
  sl.registerFactory(() => EmpOTRFormProvider(commonRepo: sl()));



}