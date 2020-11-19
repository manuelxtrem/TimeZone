import 'package:flutter/material.dart';
import 'package:world_clock/model/model.dart';
import 'package:world_clock/utils/utils.dart';

class TimeZoneData extends Model {
  String timezone;
  String name;
  String countryCode;
  String capital;

  TimeZoneData({
    this.timezone,
    this.name,
    this.countryCode,
    this.capital,
  });

  TimeZoneData.fromJson(Map<String, dynamic> map) {
    if (!Utils.isEmptyOrNull(map['timezones'])) {
      timezone = parseString(map['timezones'][0], '');
    } else {
      timezone = parseString(map['timezone'], '');
    }
    name = parseString(map['name'], '');
    countryCode = parseString(map['country_code'], '');
    capital = parseString(map['capital'], '');
  }

  Map<String, dynamic> toJson() => {
        'timezone': timezone,
        'name': name,
        'country_code': countryCode,
        'capital': capital,
      };

  @override
  bool operator ==(other) {
    return other is TimeZoneData &&
        this.name == other.name &&
        this.countryCode == other.countryCode;
  }

  @override
  int get hashCode => hashValues(name, countryCode);
}
