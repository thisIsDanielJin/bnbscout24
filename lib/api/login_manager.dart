import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bnbscout24/api/client.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String LANDLORD_TEAM_ID = '67a6333d562e8cfa48bd';

class LoginManager extends ChangeNotifier {
  models.User? _loggedInUser;
  models.User? get loggedInUser => _instance._loggedInUser;

  bool get isLoggedIn => _instance._loggedInUser != null;

  bool _isLandlord = false;
  bool get isLandlord => _instance._isLandlord;

  //apparently appwrite already handles session management
  static Future<void> checkSession() async {
    models.User? currentUser;
    try {
      currentUser = await ApiClient.account.get();
    } catch (error) {
      print(error);
    }
    if (currentUser != _instance._loggedInUser) {
      _instance._loggedInUser = currentUser;
    }
  }

  static Future<void> checkLandlord() async {
    if (!_instance.isLoggedIn) return;
    try {
      //user is only allowed to fetch this endpoint if he is member of the landlord team
      //TODO: is there a better way to solve this? maybe using User prefs?
      await ApiClient.teams.get(teamId: LANDLORD_TEAM_ID);
      _instance._isLandlord = true;
    } catch (error) {
      print(error);
      _instance._isLandlord = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await ApiClient.account
          .createEmailSession(email: email, password: password);
      final user = await ApiClient.account.get();
      _instance._loggedInUser = user;
      await checkLandlord();
      _instance.notifyListeners();
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print(error);
    }
  }

  //TODO: handle AppWrite errors for weak passwords and already taken usernames
  Future<void> register(String email, String password, String name) async {
    try {
      await ApiClient.account.create(
          userId: ID.unique(), email: email, password: password, name: name);
      await login(email, password);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print(error);
    }
  }

  Future<void> logout() async {
    try {

      await ApiClient.account.deleteSession(sessionId: 'current');
      _instance._loggedInUser = null;
      _instance.notifyListeners();
      (await SharedPreferences.getInstance()).clear();
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print(error);
    }
  }

  static Future<void> changePassword(String oldPassword, String newPassword,
      {VoidCallback? successCallback}) async {
    try {
      await ApiClient.account
          .updatePassword(password: newPassword, oldPassword: oldPassword);
      SnackbarService.showSuccess('Password changed.');
      successCallback?.call();
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print(error);
    }
  }

  static final LoginManager _instance = LoginManager._internal();
  LoginManager._internal();
  factory LoginManager() => _instance;
}
