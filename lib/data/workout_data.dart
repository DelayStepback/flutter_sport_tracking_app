import 'package:flutter/cupertino.dart';
import 'package:flutter_sport_app/data/hive_database.dart';
import 'package:flutter_sport_app/datetime/date_time.dart';
import 'package:flutter_sport_app/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(
        name: "Upper Bodys",
        exercises: [
          Exercise(
            name: "Bicep curl",
            weight: "5",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Tricep dip",
            weight: "25",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Chest press",
            weight: "2.5",
            reps: "10",
            sets: "3",
          )
        ]
    ),
    Workout(
        name: "Lower Body",
        exercises: [
          Exercise(
            name: "Squats",
            weight: "0",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Deadlifts",
            weight: "5",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Hip thrusts",
            weight: "2.5",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Lunges",
            weight: "2",
            reps: "10",
            sets: "3",
          )
        ]
    ),
    Workout(
        name: "Upper Body (low)",
        exercises: [
          Exercise(
            name: "Bicep curl",
            weight: "5",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Tricep dip",
            weight: "25",
            reps: "10",
            sets: "3",
          ),
          Exercise(
            name: "Chest press",
            weight: "2.5",
            reps: "10",
            sets: "3",
          )
        ]
    ),
  ];


  // if there are workouts already in database, then get workout list, otherwise use default workouts
  void initalizeWorkoutList(){
    if (db.previousDataExists()){
      workoutList = db.readFromDatabase();
    }
    else { // default values save
      db.saveToDatabase(workoutList);
    }

    // load heat map
    loadHeatMap();
  }

  // getting list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();

    // ********save to database*********
    db.saveToDatabase(workoutList);
  }


  // *******************************
  // delete from database
  void deleteWorkout(String name) {
    workoutList.removeWhere((element) => element.name == name);
    notifyListeners();
    // ********save to database*********
    db.saveToDatabase(workoutList);
  }



// add exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets)
    );
    notifyListeners();

    // ********save to database*********
    db.saveToDatabase(workoutList);

  }


// check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check bool

    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();

    // ********save to database*********
    db.saveToDatabase(workoutList);
    // load heat map
    loadHeatMap();
  }


  // ********************************************
  // delete exercise
  // check off exercise
  void deleteExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // then find relevant exers in workout
    relevantWorkout.exercises.removeWhere((
        exercise) => exercise.name == exerciseName);
    notifyListeners();
    // ********save to database*********
    db.saveToDatabase(workoutList);
  }


// ret relevant workout obj, than given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere((workout) =>
    workout.name == workoutName);
    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find relev workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // then find relevant exers in workout
    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((
        exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  // get start date
  String getStartDate(){
    return db.getStartDate();
  }

  /* heat
  map */

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap(){
    DateTime startDate = createDateTimeObject(getStartDate());

    // count numbers of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today, and add each compl status to the dataset

    // "COMPLETION_STATUS_yyyymmdd" will be KEY in database
    for (int i =0; i < daysInBetween+1 ;i++){
      String yyyymmdd = convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      // completion status
      int completionStatus = db.getCompletionStatus(yyyymmdd);
      // year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int> {
        DateTime(year, month, day) : completionStatus
      };

      // add to a heat map database

      heatMapDataSet.addEntries(percentForEachDay.entries);

    }


  }
}