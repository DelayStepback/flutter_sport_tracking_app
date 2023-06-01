import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  ExerciseTile(
      {Key? key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isCompleted,
      required this.onCheckboxChanged})
      : super(key: key);

  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckboxChanged;

  Color bgcolor(is_Completed){
    Color color;
    if (is_Completed){
      color = Color.fromRGBO(11, 14, 73, 0.5019607843137255);
    }
    else{
      color = Color.fromRGBO(152, 152, 152, 0.5);
    }
    return color;
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      color: bgcolor(isCompleted),
      child: ListTile(
        title: Text(exerciseName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.8),),
        subtitle: Row(
          children: [
            // weight
            Chip(label: Text("${weight}kg")),
            // reps
            Chip(label: Text("${reps} reps")),
            // sets
            Chip(label: Text("${sets} sets")),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckboxChanged!(value),
        ),
      ),
    );
  }
}
