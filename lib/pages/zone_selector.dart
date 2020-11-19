import 'package:flutter/material.dart';
import 'package:world_clock/model/timezone.dart';
import 'package:world_clock/utils/styles.dart';

class ZoneSelector extends StatefulWidget {
  final List<TimeZoneData> timezones;
  final Function(TimeZoneData) onSelected;

  const ZoneSelector({Key key, this.timezones, this.onSelected})
      : super(key: key);

  @override
  _ZoneSelectorState createState() => _ZoneSelectorState();
}

class _ZoneSelectorState extends State<ZoneSelector> {
  List<TimeZoneData> _list = [];
  TextEditingController _filter = TextEditingController();

  @override
  void initState() {
    // set default list
    _list.addAll(widget.timezones);

    // how to filter
    _filter.addListener(() {
      print('filtering => ${_filter.text}');
      setState(() {
        _list = widget.timezones
            .where((e) =>
                e.name.toLowerCase().contains(_filter.text.toLowerCase()) ||
                e.capital.toLowerCase().contains(_filter.text.toLowerCase()))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _filter,
          decoration: InputDecoration(
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: 'Search for a country'),
          style: AppStyles.normal,
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                widget?.onSelected(_list[index]);
                Navigator.of(context).pop();
              },
              leading: Icon(Icons.add_circle),
              trailing: Icon(Icons.chevron_right),
              title: Text(
                _list[index].name,
                style: AppStyles.normal.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _list[index].capital,
                style: AppStyles.normal.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              // children: [
              //   SizedBox(width: 20),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}
