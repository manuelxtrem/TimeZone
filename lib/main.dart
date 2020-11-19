import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cup;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_clock/pages/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:world_clock/model/timezone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:world_clock/utils/storage.dart';

void main() {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return MaterialApp(
      title: 'Giant Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _init(context),
        builder: (context, value) {
          if (!value.hasData) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: cup.CupertinoActivityIndicator(),
              ),
            );
          }
          return HomePage(timezones: value.data);
        },
      ),
    );
  }

  Future<List<TimeZoneData>> _init(context) async {
    var jsonn = await DefaultAssetBundle.of(context)
        .loadString('assets/countries.json');
    var obj = jsonDecode(jsonn);

    List<TimeZoneData> list = [];
    for (var item in obj) {
      list.add(TimeZoneData.fromJson(item));
    }

    var prefs = await SharedPreferences.getInstance();
    Storage _storage = Storage(prefs);

    List<TimeZoneData> _timezones = _storage.getTimezones();

    // set default timezone
    if (_timezones.isEmpty) {
      _timezones.add(TimeZoneData(
        name: 'Ghana',
        countryCode: 'GH',
        capital: 'Accra',
        timezone: 'Africa/Accra',
      ));
    }

    // cache again
    _storage.setTimezones(_timezones);

    return list;
  }
}
