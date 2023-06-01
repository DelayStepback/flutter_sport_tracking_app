import 'package:flutter/material.dart';
import 'package:flutter_sport_app/data/workout_data.dart';
import 'package:flutter_sport_app/pages/home_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async{
  // init hive
  await Hive.initFlutter();

  // open a hive box

  await Hive.openBox("workout_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: HomePage()),
    );
  }
}
