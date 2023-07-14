import 'package:isar/isar.dart';
part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  String? title;
  String? body;
  DateTime? date;
}
