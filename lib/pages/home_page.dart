import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:world_clock/pages/zone_selector.dart';
import 'package:world_clock/utils/colors.dart';
import 'package:world_clock/model/timezone.dart';
import 'package:world_clock/utils/storage.dart';
import 'package:world_clock/utils/styles.dart';
import 'package:timezone/standalone.dart';
import 'package:world_clock/utils/utils_date.dart';

class HomePage extends StatefulWidget {
  final List<TimeZoneData> timezones;

  const HomePage({Key key, @required this.timezones}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _currentTime = DateTime.now();
  List<TimeZoneData> _timezones = [];
  TimeZoneData _selectedTimezone;
  Storage _storage;
  Timer _timer;

  @override
  void initState() {
    // set default timezone
    setLocalLocation(getLocation('Africa/Accra'));

    // load cached
    Future.microtask(() => SharedPreferences.getInstance().then((prefs) {
          setState(() {
            _storage = Storage(prefs);
            _timezones.addAll(_storage.getTimezones());
            // set selected/expanded
            _selectedTimezone = _timezones.first;
          });
        }));

    // set time to refresh every minute
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    super.initState();
  }

  TZDateTime _getDate(String location) {
    return TZDateTime.from(_currentTime, getLocation(location));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Timezones',
          style: AppStyles.normal.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () => _addNewTime(),
          ),
          SizedBox(width: 15),
        ],
      ),
      backgroundColor: Colors.white,
      body: _timezones.isNotEmpty
          ? ListView(
              children: List.generate(_timezones.length, (i) => i).map((index) {
                var zone = _timezones[index];
                var time = _getDate(zone.timezone);

                return _buildTimeZoneItem(
                  background: AppColors.color[index],
                  zone: time.timeZone.abbr,
                  data: zone,
                  time: time,
                  selected: zone == _selectedTimezone,
                  onTap: () => setState(() {
                    if (_selectedTimezone != zone) {
                      _selectedTimezone = zone;
                    }
                  }),
                );
              }).toList(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'Tap the plus (+) button at the top to add a country/timezone',
                  textAlign: TextAlign.center,
                  style: AppStyles.normal.copyWith(fontSize: 24),
                ),
              ),
            ),
    );
  }

  Widget _buildTimeZoneItem({
    Color background,
    TimeZoneData data,
    String zone,
    TZDateTime time,
    bool selected = false,
    Function onTap,
  }) {
    return Dismissible(
      key: Key(data.countryCode),
      onDismissed: (direction) {
        setState(() {
          _timezones.removeWhere((e) => e.countryCode == data.countryCode);
          _storage.setTimezones(_timezones);
        });

        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("${data.name} has been removed")));
      },
      child: GestureDetector(
        onTap: () => onTap(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: selected ? 210 : 120,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: background,
          ),
          child: Row(
            children: [
              WebsafeSvg.asset(
                time.hour > 12 ? 'assets/moon.svg' : 'assets/sun.svg',
                width: 40,
                color: Colors.white,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    selected ? _buildTime(time, true) : Container(),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.only(left: selected ? 15 : 0),
                      child: Text(
                        data.capital,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.normal.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.only(left: selected ? 15 : 0),
                      child: Text(
                        '${data.name.toUpperCase()}, $zone',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.normal.copyWith(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !selected ? _buildTime(time, false) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTime(DateTime time, bool large) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // '$hour:$minute',
          DateUtils.formatDateTime(time, 'hh') +
              ':' +
              DateUtils.formatDateTime(time, 'mm'),
          style: AppStyles.normal.copyWith(
            color: Colors.white,
            fontSize: large ? 65 : 37,
            fontWeight: large ? FontWeight.w500 : FontWeight.w200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateUtils.formatDateTime(time, 'a').toLowerCase(),
                style: AppStyles.normal.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: large ? FontWeight.w500 : FontWeight.w300,
                ),
              ),
              large
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateUtils.formatDateTime(time, 'EEE, MMM d'),
                        style: AppStyles.normal.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: large ? FontWeight.w500 : FontWeight.w300,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  void _addNewTime() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(
          'Add a Timezone',
          style: AppStyles.normal.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        contentPadding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            width: 300,
            height: 400,
            child: ZoneSelector(
              timezones: widget.timezones,
              onSelected: (zone) {
                setState(() {
                  var after = _storage.addToTimezones(zone);
                  _timezones.clear();
                  _timezones.addAll(after);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
