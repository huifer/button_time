import 'package:button_time/biz/db.dart';

import 'Task.dart';

Future<List<Task>> taskList() async {
  var db = await DatabaseHelper.internal().db;

  List<Map<String, dynamic>> maps =
      await db.query("task", orderBy: "create_time DESC");

  if (maps.isEmpty) {
    return [];
  }
  List<Task> tasks = List<Task>.from(maps.map((map) => Task.fromMap(map)));

  return tasks;
}
