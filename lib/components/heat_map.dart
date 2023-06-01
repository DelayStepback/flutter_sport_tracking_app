import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_sport_app/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
        fontSize: 19,
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 2)),
        datasets: datasets,
        colorMode: ColorMode.opacity,
        defaultColor: Color.fromRGBO(0, 12, 255, 1.0),
        textColor: Color.fromRGBO(184, 184, 184, 1),
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromRGBO(47, 255, 0, 0.1),
          2: Color.fromRGBO(47, 255, 0, 0.2),
          5: Color.fromRGBO(47, 255, 0, 0.4),
          7: Color.fromRGBO(47, 255, 0, 0.66),
          9: Color.fromRGBO(47, 255, 0, 0.7),
          12: Color.fromRGBO(47, 255, 0, 1),
        },
      ),
    );
  }
}
