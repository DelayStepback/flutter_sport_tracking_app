import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapPage extends StatefulWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;
  const HeatMapPage({Key? key, this.datasets, required this.startDateYYYYMMDD})
      : super(key: key);

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              title: Text('Exercise Calendar'),
              elevation: 0.0,
              centerTitle: true,
            ),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(18,38,84,0.8),
        ),
        child: Center(

          child: HeatMapCalendar(
            onClick: (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value.toString())));
            },

            fontSize: 19,
            weekFontSize: 19,
            monthFontSize: 19,
            borderRadius: 5,
            weekTextColor: Colors.white,
            datasets: widget.datasets,
            // {DateTime(2023, 5, 2): 3,}
            colorMode: ColorMode.color,
            defaultColor: Color.fromRGBO(0, 0, 0, 0.2),
            textColor: Colors.white,
            showColorTip: false,
            size: 50,
            colorsets: const {
              0: Colors.grey,
              1: Color.fromRGBO(47, 255, 0, 0.1),
              2: Color.fromRGBO(47, 255, 0, 0.2),
              5: Color.fromRGBO(47, 255, 0, 0.4),
              7: Color.fromRGBO(47, 255, 0, 0.66),
              9: Color.fromRGBO(47, 255, 0, 0.7),
              12: Color.fromRGBO(47, 255, 0, 1),
            },
          ),
        ),
      ),
    );
  }
}
