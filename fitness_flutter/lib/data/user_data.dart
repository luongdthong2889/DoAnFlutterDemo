import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/data/workout_data.dart';

class UserData {
  final String name;
  final String photo;
  final String mail;
  final List<WorkoutData>? workouts;

  UserData({
    required this.name,
    required this.photo,
    required this.mail,
    required this.workouts,
  });

    @override
  String toString() {
    return 'UserData(name: $name, photo: $photo, mail: $mail, workouts: $workouts)';
  }

  static fromFirebase(User? user) {
    return user != null
        ? UserData(
            name: user.displayName ?? "",
            photo: user.photoURL ?? "",
            mail: user.email ?? "",
            workouts: [],
          )
        : [];
  }
}