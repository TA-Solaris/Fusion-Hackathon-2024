import 'package:fusionclock/src/models/user.dart';

class Alarm {
  int id;
  int streak;
  DateTime time;
  int daysSet;
  User user;

  Alarm(this.id, this.streak, this.time, this.daysSet, this.user);
}
