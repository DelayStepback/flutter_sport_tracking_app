import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sport_app/data/workout_data.dart';
import 'package:flutter_sport_app/pages/workout_page.dart';
import 'package:provider/provider.dart';
import 'heat_map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  // create new workout
  final newWorkoutNameController = TextEditingController();
  final editWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor:
                  Color.fromRGBO(255, 255, 255, 0.8235294117647058),
              title: Text(
                "Создать новую тренировку",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: Text("Сохранить"),
                ),
                // cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Отмена"),
                )
              ],
            ));
  }

//same createNewWorkout
  void editWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor:
          Color.fromRGBO(255, 255, 255, 0.8235294117647058),
          title: Text(
            "Создать новую тренировку",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: editWorkoutNameController,
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: save,
              child: Text("Сохранить"),
            ),
            // cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text("Отмена"),
            )
          ],
        )
    );
  }


  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(workoutName: workoutName)));
  }

  void goToHeatMapPage(datasets, startDateYYYYMMDD) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HeatMapPage(startDateYYYYMMDD: startDateYYYYMMDD, datasets: datasets,)));
  }

  // save workout
  void save() {
    // getting workout name from controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    // pop dialog if save
    Navigator.pop(context);
    // clear input field
    clear();
    goToWorkoutPage(newWorkoutName);
  }
  // delete workout
  void delete(BuildContext context, workoutName) {
    // getting workout name from controller
   // context.

    String delWorkoutName = workoutName;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).deleteWorkout(delWorkoutName);

    // pop dialog if save
    // clear input field
    clear();

  }


  // cancel workout
  void cancel() {
    // pop dialog if save
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
    editWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(

        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AppBar(
                backgroundColor: Colors.black.withOpacity(0.2),
                title: Text('Exercise Explorer'),
                elevation: 0.0,
                centerTitle: true,

              ),
            ),
          ),
          preferredSize: Size(double.infinity, 56.0,  ),
        ),

        // нижние иконки
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () {
                goToHeatMapPage(
                    value.heatMapDataSet, value.getStartDate());
              },
              child: Icon(Icons.calendar_month),
            ),
            FloatingActionButton(
              onPressed: createNewWorkout,
              child: Icon(Icons.add),
            ),
          ],
        ),
        // лист
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/mainplate.jpeg'),
            fit: BoxFit.fitHeight
            )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0,sigmaY: 3.0),
              child: ListView(
                children: [
                  // WORKOUT LIST
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.getWorkoutList().length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Slidable(
                              key: ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  // SlidableAction(
                                  //   flex: 2,
                                  //   onPressed: (context) => editWorkout(), //editWorkout ,
                                  //   backgroundColor: Colors.green,
                                  //   foregroundColor: Colors.white,
                                  //   icon: Icons.edit,
                                  //   label: 'Edit',
                                  // ),
                                  SlidableAction(
                                    flex: 3,
                                    onPressed: (context) => delete(context,value.getWorkoutList()[index].name ),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                trailing: SizedBox(
                                  width: 300,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16))),
                                    onPressed: () {
                                      goToWorkoutPage(
                                          value.getWorkoutList()[index].name);
                                    },
                                    icon: Icon(
                                      Icons.accessibility_new_rounded  ,                                    size: 35,
                                      color: Colors.white,
                                    ),
                                    label: Text(value.getWorkoutList()[index].name,
                                        style: TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
