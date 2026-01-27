import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {
  static String userid ="userid";
  static String mobileNumber ="mobileNumber";
  static String UserNameRem ="UserNameRem";
  static String sHGID ="sHGID";
  static String mEMBERID ="mEMBERID";
  static String mIMEIn ="mIMEIn";
  static String VERSION ="VERSION";


  static const String USER_LOGGEDIN_WAY = "USER_LOGGEDIN_WAY";

  static Future<void> setVERSION(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(VERSION, value);
  }


  static Future<String?> getVERSION() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(VERSION);
  }

  static Future<void> setmIMEIn(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(mIMEIn, value);
  }


  static Future<String?> getmIMEIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(mIMEIn);
  }
  static Future<void> setmobileNumber(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(mobileNumber, value);
  }


  static Future<String?> getmobileNumber() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(mobileNumber);
  }

  static Future<void> setsHGID(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(sHGID, value);
  }


  static Future<String?> getsHGID() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(sHGID);
  }
  static Future<void> setmEMBERID(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(mEMBERID, value);
  }


  static Future<String?> getmEMBERID() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(mEMBERID);
  }
  static Future<void> setUserNameRem(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(UserNameRem, value);
  }


  static Future<String?> getUserNameRem() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(UserNameRem);
  }


  static Future<void> setUserLoggedWay(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(USER_LOGGEDIN_WAY, value);
  }


  static Future<String?> getUserLoggedWay() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USER_LOGGEDIN_WAY);
  }



// *****************Apna APp **************


  static Future<void> setAAadhare(String aadhaar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhaar_id', aadhaar);
  }

  static Future<String?> getAAadhare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('aadhaar_id');
  }

  static Future<void> setVid(String vid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhaar_vid', vid);
  }

  static Future<String?> getVid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('aadhaar_vid');
  }

}
