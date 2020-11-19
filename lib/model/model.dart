import 'dart:convert';

import 'package:world_clock/utils/utils.dart';
import 'package:world_clock/utils/utils_date.dart';

typedef ModelObjectCast<T> = T Function(Map<String, dynamic>);

class Model {
  Model();

  Model fromJson(Map<String, dynamic> json) {
    return this;
  }

  Map<String, dynamic> toJson() {
    throw ('Unimplemented method');
  }

  Model.fromJson(Map<String, dynamic> map) {
    throw ('Unimplemented method');
  }

  int parseInt(dynamic value, [int defaultValue = 0]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return Utils.parseInt(value);
  }

  String parseString(dynamic value, [String defaultValue]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return '$value';
  }

  double parseDouble(dynamic value, [double defaultValue = 0]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return Utils.parseDouble(value);
  }

  bool parseBoolean(dynamic value, [bool defaultValue = false]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return value == true || value == 'true' || value == 1 || value == '1';
  }

  List<T> parseList<T>(dynamic value, ModelObjectCast<T> dataObject) {
    if (Utils.isEmptyOrNull(value)) return [];

    // guess its a json string
    if (value is String) {
      value = json.decode(value);
    }

    final List<T> list = [];
    for (var item in value) {
      list.add(dataObject(item));
    }

    return list;
  }

  DateTime parseDateTime(dynamic value, [DateTime defaultValue]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return DateUtils.parse(value);
  }

  String toDateTimeString(DateTime value, [String defaultValue]) {
    if (Utils.isEmptyOrNull(value)) return defaultValue;
    return DateUtils.formatDateTime(value, 'd MMM yyyy');
  }

  int toUnixTimestamp(DateTime value) {
    return value?.unixTimestamp ?? 0;
  }
}
