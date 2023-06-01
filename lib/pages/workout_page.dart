import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sport_app/components/exercise_tile.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    // checkbox was tapped
    void onCheckBoxChanged(String workoutName, String exerciseName) {
      Provider.of<WorkoutData>(context, listen: false)
          .checkOffExercise(workoutName, exerciseName);
    }

    // text controllers

    final exerciseNameController = TextEditingController();
    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final setsController = TextEditingController();

    void clear() {
      exerciseNameController.clear();
      weightController.clear();
      repsController.clear();
      setsController.clear();
    }
    // save workout
    void save() {
      // getting exercise name from controller
      String newExerciseName = exerciseNameController.text;
      String weight = weightController.text;
      String reps = repsController.text;
      String sets = setsController.text;

      // add exercise to workoutdata list
      Provider.of<WorkoutData>(context, listen: false).addExercise(
          widget.workoutName, newExerciseName, weight, reps, sets);

      // pop dialog if save
      Navigator.pop(context);
      // clear input field
      clear();
    }

    // cancel workout
    void cancel() {
      // pop dialog if save
      Navigator.pop(context);
      clear();
    }

    void delete(BuildContext context, workoutName, exerciseName) {
      // getting workout name from controller
      // context.

      String delWorkoutName = workoutName;
      String delExerciseName = exerciseName;

      Provider.of<WorkoutData>(context, listen: false).deleteExercise(delWorkoutName, delExerciseName);

      clear();

    }



    void createNewExercise() {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Создать новое упражнение"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // name
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Название',
              ),
              controller: exerciseNameController,
            ),
            SizedBox(height: 10,),
            // weight
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Вес',
              ),
              controller: weightController,
            ),
            SizedBox(height: 10,),
            // reps

            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Количество повторений',
              ),
              controller: repsController,
            ),
            SizedBox(height: 10,),
            // sets
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Количество подходов',
              ),
              controller: setsController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(onPressed: save,
                  child: Text("Сохранить"),),
                // cancel button
                MaterialButton(onPressed: cancel,
                  child: Text("Закрыть"),)
              ],
            )
            // save button

          ],
        ),
      ));
    }





    return Consumer<WorkoutData>(
        builder: (context, value, child) =>
            Scaffold(
                extendBodyBehindAppBar: true,
                appBar: PreferredSize(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: AppBar(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        title: Text(widget.workoutName),
                        elevation: 0.0,
                        centerTitle: true,

                      ),
                    ),
                  ),
                  preferredSize: Size(double.infinity, 56.0, ),
                ),



                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: createNewExercise,
                ),




                body: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(26, 58, 131, 0.8),
                  ),
                  child: ListView.builder(
                      itemCount: value.numberOfExercisesInWorkout(
                          widget.workoutName),
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Slidable(
                            key: ValueKey(0),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 3,
                                  onPressed: (context) => delete(context,widget.workoutName, value
                                      .getRelevantWorkout(widget.workoutName)
                                      .exercises[index]
                                      .name ),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(

                              child: ExerciseTile(
                                exerciseName: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .name,
                                weight: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .weight,
                                reps: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .reps,
                                sets: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .sets,
                                isCompleted: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .isCompleted,
                                onCheckboxChanged: (val) =>
                                    onCheckBoxChanged(
                                        widget.workoutName,
                                        value
                                            .getRelevantWorkout(widget.workoutName)
                                            .exercises[index]
                                            .name),
                              ),
                            ),
                          ))),
                )));
  }
}
