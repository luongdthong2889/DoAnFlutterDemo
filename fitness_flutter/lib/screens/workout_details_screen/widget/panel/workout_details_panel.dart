import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/const/path_constants.dart';
import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/data/exercise_data.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/screens/workout_details_screen/bloc/workout_details_bloc.dart';
import 'package:fitness_flutter/screens/workout_details_screen/widget/panel/workout_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkoutDetailsPanel extends StatelessWidget {
  final WorkoutData workout;

  WorkoutDetailsPanel({required this.workout});

  @override
  Widget build(BuildContext context) {
    return _createPanelData(context);
  }

  Widget _createPanelData(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _createRectangle(),
        const SizedBox(height: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createHeader(),
              const SizedBox(height: 20),
              _createWorkoutData(context),
              SizedBox(height: 20),
              _createExerciesList(),
            ],
          ),
        ),
      ],
    );
  }
   Widget _createRectangle() {
    return Image(image: AssetImage(PathConstants.rectangle));
  }

  Widget _createHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        workout.title! + "  " + TextConstants.workout,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _createWorkoutData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          WorkoutTag(
            icon: PathConstants.timeTracker,
            content: "${_getExerciseTime()}:00",
          ),
          const SizedBox(width: 15),
          WorkoutTag(
            icon: PathConstants.exerciseTracker,
            content:
                '${workout.exerciseDataList!.length} ${TextConstants.exercisesLowercase}',
          ),
        ],
      ),
    );
  }
  int _getExerciseTime() {
    int time = 0;
    final List<int?> exerciseList =
        workout.exerciseDataList!.map((e) => e.minutes).toList();
    exerciseList.forEach((e) {
      time += e!;
    });
    return time;
  }

  Widget _createExerciesList() {
    return BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
      buildWhen: (_, currState) => currState is ReloadWorkoutDetailsState,
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExercisesList(
              exercises: workout.exerciseDataList ?? [],
              workout: workout,
            ),
          ),
        );
      },
    );
  }
}

class ExercisesList extends StatelessWidget {
  final WorkoutData workout;
  final List<ExerciseData> exercises;

  const ExercisesList({required this.exercises, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 10),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ExerciseCell(
          currentExercise: exercises[index],
          nextExercise:
              index == exercises.length - 1 ? null : exercises[index + 1],
          workout: workout,
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 15);
      },
    );
  }
}


class ExerciseCell extends StatelessWidget {
  final WorkoutData workout;
  final ExerciseData currentExercise;
  final ExerciseData? nextExercise;
  final int index;

  const ExerciseCell({
    required this.currentExercise,
    required this.workout,
    required this.nextExercise,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutDetailsBloc>(context);
    return BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
      buildWhen: (_, currState) => currState is WorkoutExerciseCellTappedState,
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            bloc.add(
              StartTappedEvent(
                workout: workout,
                index: index,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.textBlack.withOpacity(0.12),
                  blurRadius: 5.0,
                  spreadRadius: 1.1,
                ),
              ],
            ),
            child: Row(
              children: [
                _createImage(),
                const SizedBox(width: 10),
                Expanded(
                  child: _createExerciseTextInfo(),
                ),
                const SizedBox(width: 10),
                _createRightArrow(),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _createImage() {
    return Container(
      width: 75,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(workout.image ?? ""),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  Widget _createExerciseTextInfo() {
    final minutesStr = "${currentExercise.minutes} minutes";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentExercise.title ?? "",
          style: TextStyle(
            color: ColorConstants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          minutesStr,
          style: TextStyle(
            color: ColorConstants.textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 11),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: LinearPercentIndicator(
            percent: currentExercise.progress ?? 0,
            progressColor: ColorConstants.primaryColor,
            backgroundColor: ColorConstants.primaryColor.withOpacity(0.12),
            lineHeight: 6,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
  Widget _createRightArrow() {
    return RotatedBox(
      quarterTurns: 2,
      child: Image(
        image: AssetImage(PathConstants.back),
      ),
    );
  }
}