import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_clock/model/model.dart';
import 'package:world_clock/model/timezone.dart';
import 'package:world_clock/utils/shared_settings.dart';

class Storage extends SharedSettings with ChangeNotifier {
  static const String TIMEZONES = "timezones";

  Storage(SharedPreferences prefs) : super(prefs);

  List<TimeZoneData> getTimezones() {
    final obj = getObjectFromPrefs(TIMEZONES);
    return obj != null
        ? Model().parseList(obj['list'], (map) => TimeZoneData.fromJson(map))
        : List<TimeZoneData>();
  }

  void setTimezones(List<TimeZoneData> timezones) {
    return setAndSaveObject(TIMEZONES, {'list': timezones});
  }

  List<TimeZoneData> addToTimezones(TimeZoneData timezone) {
    List<TimeZoneData> list = getTimezones();

    // add onnly if not more than 15
    if (list.length < 15) {
      // doesnt exist already
      if (list.where((e) => e.countryCode == timezone.countryCode).isEmpty) {
        list.add(timezone);
      }
    }

    setTimezones(list);
    return list;
  }
}
