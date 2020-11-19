import 'package:flutter/material.dart';

class Utils {
  ///
  /// check if provided object is empty
  ///
  static bool isEmptyOrNull(Object obj) {
    // return true if obj is null
    if (obj == null) {
      return true;
    }

    // if its a number and is zero
    if (obj is int || obj is double) {
      return obj == 0;
    }

    // if its an empty string
    if (obj is String) {
      return obj.trim() == '';
    }

    // if its an empty array
    if (obj is Iterable) {
      return obj.length == 0;
    }

    return false;
  }

  ///
  /// print console logs depending on environment
  ///
  static log(Object value) {
    print('CONSOLE :: ' + value.toString());
  }

  static String toQueryString(Map<String, dynamic> map) {
    Iterable<String> keys = map.keys;
    List keysList = keys.toList();
    keysList.sort((a, b) => a.compareTo(b));
    var generalString = List();
    for (var i = 0; i < keysList.length; i++) {
      var key = keysList[i];
      var value = map[key];
      var data = "$key=$value";
      generalString.add(data);
    }
    var result = generalString.join("&");
    return result;
  }

  static double parseDouble(dynamic obj) {
    return double.parse(isEmptyOrNull(obj) ? '0' : obj.toString());
  }

  static int parseInt(dynamic obj) {
    return int.parse(isEmptyOrNull(obj) ? '0' : obj.toString());
  }
}
