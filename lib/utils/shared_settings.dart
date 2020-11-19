import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedSettings {
  SharedPreferences _prefs;

  SharedSettings(SharedPreferences prefs) {
    _prefs = prefs;
  }

  void setAndSaveObject(String key, Map value) {
    _prefs.setString(key, json.encode(value));
  }

  void setAndSaveList(String key, List value) {
    _prefs.setString(key, json.encode(value));
  }

  void setAndSaveString(String key, String value) {
    _prefs.setString(key, value);
  }

  void setAndSaveInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  void setAndSaveBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  Map<String, dynamic> getObjectFromPrefs(String key) {
    try {
      String jsonString = _prefs.getString(key);

      if (jsonString == null) return null;

      return json.decode(jsonString);
    } catch (e) {
      return null;
    }
  }

  List<dynamic> getListFromPrefs(String key) {
    try {
      String jsonString = _prefs.getString(key);

      if (jsonString == null) return null;

      return json.decode(jsonString);
    } catch (e) {
      return null;
    }
  }

  String getStringFromPrefs(String key) {
    try {
      return _prefs.getString(key) ?? "";
    } catch (e) {
      return "";
    }
  }

  int getIntFromPrefs(String key) {
    try {
      return _prefs.getInt(key) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  bool getBoolFromPrefsDefaultTrue(String key) {
    try {
      return _prefs.getBool(key) ?? true;
    } catch (e) {
      return true;
    }
  }

  bool getBoolFromPrefsDefaultFalse(String key) {
    try {
      return _prefs.getBool(key) ?? false;
    } catch (e) {
      return false;
    }
  }
}
