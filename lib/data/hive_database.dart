import 'package:flutter_sport_app/datetime/date_time.dart';
import 'package:flutter_sport_app/models/exercise.dart';
import 'package:hive/hive.dart';

import '../models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database");

  // check if there already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data base NOT exists");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data exists");
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert obj to -> string
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*
    check if any exercise have been done
    */

    // example: COMPLETION_STATUS_20230416 + 5 ( 5 exircesies have done )
    // if (exerciseCompleted(workouts)) {
    //   _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    // } else {
    //   _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    // }

    _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", exerciseCompleted(workouts));
    // save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data, and return list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // workout <- multiple exercises
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // add exercise to list
        exerciseInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));
      }
      // create indiv workout
      Workout workout = Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

      // add indiv workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  // check if any exercise have been done
  int exerciseCompleted(List<Workout> workouts) {
    int s = 0;
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          s++;
        }
      }
    }
    return s;
  }

// return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd){
    // returns 0 or 1, if null return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    // [день ног[упр[10,20,20], упр2[..]], день рук]
  ];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts the exercise in a workout obj into a list of string (cause Hive work only this type)
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    // get exercises
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      //  упр[10,20,20]
    ];

    // go through each exercise in exerciseList
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        // [ноги, 10кг,10репс,10сетс]
      ];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
