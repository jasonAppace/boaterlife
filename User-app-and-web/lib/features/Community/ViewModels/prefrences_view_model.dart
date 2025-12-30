import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class PreferencesViewModel extends BaseViewModel {
  String? userToken;
  String? fcmToken;
  int? userID;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userCompany;
  String? userPhoneAlt;

  // Save and get user token
  Future saveUserToken(String tokenValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("tokenValue", tokenValue);
    userToken = tokenValue;
    notifyListeners();
  }

  Future getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userToken = await sharedPreferences.getString("tokenValue");
    notifyListeners();
  }

  Future removeUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("tokenValue");
    notifyListeners();
  }

  // Save and get FCM token
  Future saveFCMToken(String tokenValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("FCMtokenValue", tokenValue);
    fcmToken = tokenValue;
    notifyListeners();
  }

  Future getFCMToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fcmToken = await sharedPreferences.getString("FCMtokenValue");
    notifyListeners();
  }

  // Save and get user ID
  Future saveUserID(int userID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("userID", userID);
    this.userID = userID;
    notifyListeners();
  }

  Future getUserID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userID = await sharedPreferences.getInt("userID");
    notifyListeners();
  }

  // Save and get user name
  Future saveUserName(String fullname) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("fullname", fullname);
    userName = fullname;
    notifyListeners();
  }

  Future getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName = await sharedPreferences.getString("fullname");
    notifyListeners();
  }

  Future removeUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("fullname");
    notifyListeners();
  }

  // Save and get user email
  Future saveUserEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("email", email);
    userEmail = email;
    notifyListeners();
  }

  Future getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userEmail = await sharedPreferences.getString("email");
    notifyListeners();
  }

  Future removeUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("email");
    notifyListeners();
  }

  // Save and get user company
  Future saveUserCompany(String company) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("company", company);
    userCompany = company;
    notifyListeners();
  }
}
