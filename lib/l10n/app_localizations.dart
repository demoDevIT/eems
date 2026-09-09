import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgetpass.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forgetpass;

  /// No description provided for @rememberme.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberme;

  /// No description provided for @ssoid.
  ///
  /// In en, this message translates to:
  /// **'SSO ID'**
  String get ssoid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @donthaveaccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get donthaveaccount;

  /// No description provided for @dosignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get dosignup;

  /// No description provided for @searchhere.
  ///
  /// In en, this message translates to:
  /// **'Search Here...'**
  String get searchhere;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @updateprofile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get updateprofile;

  /// No description provided for @scheduledinterviews.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Interviews'**
  String get scheduledinterviews;

  /// No description provided for @cvbuilder.
  ///
  /// In en, this message translates to:
  /// **'CV Builder'**
  String get cvbuilder;

  /// No description provided for @searchJobApply.
  ///
  /// In en, this message translates to:
  /// **'Search Job/Apply'**
  String get searchJobApply;

  /// No description provided for @searchcounselor.
  ///
  /// In en, this message translates to:
  /// **'Search Counselor'**
  String get searchcounselor;

  /// No description provided for @jobfairevents.
  ///
  /// In en, this message translates to:
  /// **'Job Fair events'**
  String get jobfairevents;

  /// No description provided for @downldregiscard.
  ///
  /// In en, this message translates to:
  /// **'Download Registration Card'**
  String get downldregiscard;
  String get mysyStatus;

  /// No description provided for @grievfeedbak.
  ///
  /// In en, this message translates to:
  /// **'Grievance/Feedback'**
  String get grievfeedbak;

  /// No description provided for @selfassess.
  ///
  /// In en, this message translates to:
  /// **'Self Assessment'**
  String get selfassess;

  /// No description provided for @appntmntschdl.
  ///
  /// In en, this message translates to:
  /// **'Appointment Schedule'**
  String get appntmntschdl;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @schemes.
  ///
  /// In en, this message translates to:
  /// **'Schemes'**
  String get schemes;

  /// No description provided for @viewall.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewall;

  /// No description provided for @applynow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now,'**
  String get applynow;

  /// No description provided for @jobevents.
  ///
  /// In en, this message translates to:
  /// **'Job Events'**
  String get jobevents;

  /// No description provided for @jobsbasedprofile.
  ///
  /// In en, this message translates to:
  /// **'Jobs based on your profile'**
  String get jobsbasedprofile;

  /// No description provided for @featurcompany.
  ///
  /// In en, this message translates to:
  /// **'Featured Companies'**
  String get featurcompany;

  /// No description provided for @compltprofle.
  ///
  /// In en, this message translates to:
  /// **'Complete your Profile'**
  String get compltprofle;

  /// No description provided for @basicdetl.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicdetl;

  /// No description provided for @addinfo.
  ///
  /// In en, this message translates to:
  /// **'Address Info'**
  String get addinfo;

  /// No description provided for @edudetl.
  ///
  /// In en, this message translates to:
  /// **'Education Details'**
  String get edudetl;

  /// No description provided for @workexp.
  ///
  /// In en, this message translates to:
  /// **'Work experience'**
  String get workexp;

  /// No description provided for @jobpref.
  ///
  /// In en, this message translates to:
  /// **'Job Preference'**
  String get jobpref;

  /// No description provided for @langskill.
  ///
  /// In en, this message translates to:
  /// **'Language/Skills'**
  String get langskill;

  /// No description provided for @physattri.
  ///
  /// In en, this message translates to:
  /// **'Physical Attributes'**
  String get physattri;

  /// No description provided for @videoprof.
  ///
  /// In en, this message translates to:
  /// **'Video Profile'**
  String get videoprof;

  /// No description provided for @internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get internet_connection;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @faqWelcomeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the RRP Bot'**
  String get faqWelcomeQuestion;

  /// No description provided for @faqWelcomeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the RRP Bot and I am here to help you. Please choose the option which best describes your query for me to help you better.'**
  String get faqWelcomeAnswer;

  /// No description provided for @quickServices.
  ///
  /// In en, this message translates to:
  /// **'Quick Services'**
  String get quickServices;

  String get searchRegNo;
  String get scanQRCode;
  String get role;
  String get officeName;
  String get updateProfile;
  String get requestDMap;
  String get logoutConfirmMsg;
  String get logoutThankYouText;
  String get cancel;
  String get yeslogout;
  String get enterRegNo;
  String get internJoin;
  String get internAttend;
  String get dmapReqForm;
  String get name;
  String get mobileNo;
  String get nameAsPerAdhar;
  String get presentDept;
  String get internOfficeDept;
  String get remarks;
  String get enterRemarks;
  String get submit;
  String get addBasicInfo;
  String get basicDetails;
  String get officerSSOID;
  String get officerName;
  String get nameAsPerAdharNote;
  String get designationAsPerSSO;
  String get adminDept;
  String get district;
  String get selectDistrict;
  String get department;
  String get selectDepartment;
  String get internOfficeName;
  String get selectOffice;
  String get confrmSubmision;
  String get areYouSureSubmitForm;
  String get save;
  String get plzentrnamAsAdhar;
  String get plzentrmobilNo;
  String get forAnyQuery;
  String get noRecord;
  String get regNo;
  String get fName;
  String get gender;
  String get dob;
  String get appDate;
  String get approvalDate;
  String get allocDate;
  String get dept;
  String get allotedDept;
  String get joinStatus;
  String get viewJoinLetter;
  String get approveJoin;
  String get registrationNo;
  String get search;
  String get clear;
  String get category;
  String get joinDate;
  String get joinLetter;
  String get attendYear;
  String get attendMonth;
  String get attendUploadOn;
  String get attendStatus;
  String get attendLetter;
  String get markAttend;
  String get view;
  String get year;
  String get month;
  String get selectYear;
  String get selectMonth;
  String get wholeMonthAbsent;
  String get nameAsPerJanAdhar;
  String get fullName;
  String get enterFullName;
  String get enterFName;
  String get mName;
  String get enterMName;
  String get enterMobileNo;
  String get email;
  String get enterEmail;
  String get maritalStatus;
  String get religion;
  String get selectReligion;
  String get caste;
  String get selectCaste;
  String get adharRefNo;
  String get enterAdharRefNo;
  String get minority;
  String get male;
  String get female;
  String get other;
  String get exSerMan;
  String get yes;
  String get no;
  String get ewsBanificiary;
  String get familyIncome;
  String get enterFamilyIncome;
  String get addOtherInfo;
  String get uidType;
  String get uidNumber;
  String get addressInfo;
  String get perAddAsPerJanadhar;
  String get ifAnyChanges;
  String get city;
  String get selectCity;
  String get ward;
  String get selectWard;
  String get territoryType;
  String get rural;
  String get urban;
  String get address;
  String get pincode;
  String get communicationAdd;
  String get sameAsAbove;
  String get plzSelectDistrict;
  String get plzSelectCity;
  String get plzSelectWard;
  String get plzSelectTeriType;
  String get plzEnterAddress;
  String get plzEnterPincode;
  String get plzSelectAssemConsti;
  String get plzSelectParliConsti;
  String get alert;
  String get eduDetail;
  String get addEduDetail;
  String get areYouWantToDelete;
  String get ncoCode;
  String get uniBoard;
  String get colSch;
  String get mode;
  String get medium;
  String get passYear;
  String get workExp;
  String get addWorkExp;
  String get asPerOTRForm;
  String get empStatus;
  String get expYear;
  String get ExpMonth;
  String get langNskill;
  String get addSkill;
  String get addLang;
  String get skillSumry;
  String get langKnow;
  String get addLangSkill;
  String get acqThro;
  String get phyAttri;
  String get phyAttriSumry;
  String get updatePhyAttri;
  String get phyDetail;
  String get height;
  String get chest;
  String get eyeSight;
  // String get pwd;
  String get disability;
  String get percentage;
  String get weight;
  String get jobPref;
  String get areYouIntIntJob;
  String get update;
  String get noteMax5Job;
  String get addJobPref;
  String get jobType;
  String get shift;
  String get expSal;
  String get updateJobPref;
  String get plzSelPreLoc;
  String get add;
  String get kinChoseJobPrefMatchQuaWorkExp;
  String get sector;
  String get prefLoc;
  String get selOption;
  String get desEmpType;
  String get desJobType;
  String get expSalRanMon;
  String get plzSelNcoCodJobPref;
  String get videoProfile;
  String get recordLiveIntVideo;
  String get recordVideo4Step;
  String get create45SecVideo;
  String get skip;
  String get startRec;
  String get noVideoAvail;
  String get cvBuilder;
  String get downloadCV;
  String get prefRecomJobs;
  String get appJobs;
  String get prefJobs;
  String get filter;
  String get searchJobTitle;
  String get searchByLocation;
  String get selSector;
  String get searchSector;
  String get jobBasedUrProfile;
  String get apply;
  String get salary;
  String get confirm;
  String get areYouWantApply;
  String get somethingWrong;
  String get noAppJobFound;
  String get events;
  String get regEvents;
  String get fromDate;
  String get endDate;
  String get fromDateNotGreaterEndDate;
  String get applyFilter;
  String get eventID;
  String get startDate;
  String get level;
  String get venue;
  String get selectDate;
  String get downRegCard;
  String get areYouWantDownload;
  String get JobSeekRegCard;
  String get regDate;
  String get exchangeName;
  String get highQua;
  String get perAddress;
  String get commAddress;
  String get mysyList;
  String get applyDate;
  String get approveDate;
  String get stoppedDate;
  String get msgLogs;
  String get joinLogs;
  String get attendLogs;
  String get docLogs;
  String get paymentLogs;
  String get grieAsignForm;
  String get noDataFound;
  String get complainNo;
  String get subject;
  String get cateType;
  String get module;
  String get status;
  String get createdOn;
  String get viewTrail;
  String get subModule;
  String get subRelComplain;
  String get enterSubRelComplain;
  String get uploadAttachment;
  String get selectUploadAttachment;
  String get plzSelCate;
  String get plzSelCateType;
  String get plzSelModule;
  String get plzSelSubModule;
  String get plzEnterSub;
  String get plzEnterRemark;
  String get selfAssessTest;
  String get overview;
  String get overviewContent;
  String get keyFeature;
  String get selfAssessKeyFeature1;
  String get selfAssessKeyFeature2;
  String get selfAssessKeyFeature3;
  String get selfAssessKeyFeature4;
  String get selfAssessKeyFeature5;
  String get selfAssessKeyFeature6;
  String get selfAssessKeyFeature7;
  String get benefits;
  String get benifit1;
  String get benifit2;
  String get benifit3;
  String get benifit4;
  String get continuee;
  String get sel1CatForAssess;
  String get psychometric;
  String get startTest;
  String get assessInstr;
  String get generalInstr;
  String get selCate;
  String get totalQues;
  String get totalDuration;
  String get minutes;
  String get doNotRefreshTest;
  String get eachQuesAnsBfrProceed;
  String get onceSubmtAnsNotChange;
  String get selfAssessInstr;
  String get onlyOneAnsPerQues;
  String get correctAnsMark;
  String get attAllQuesCare;
  String get psychoInstr;
  String get noRightWrong;
  String get ansBasedBehaviour;
  String get doNotOverthink;
  String get jobAlert;
  String get privacy;
  String get profileVisibleRequiters;
  String get support;
  String get aboutApp;
  String get viewProfile;
  String get areYouSureLogOut;
  String get skillKnown;
  String get skillCate;
  String get skillSubCate;
  String get acquThro;
  String get experience;
  String get enterYear;
  String get enterMonth;
  String get uploadSkillCert;
  String get uploadImage;
  String get uploadPDF;
  String get language;

}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
