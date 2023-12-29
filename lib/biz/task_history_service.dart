import 'package:button_time/biz/db.dart';
import 'package:sqflite/sqflite.dart';

import 'Task.dart';
import 'task_history.dart';

Future<TaskHistory> saveTaskHistory(TaskHistory taskHistory) async {
  print("保存任务历史");
  var db = await DatabaseHelper.internal().db;

  var t = await db.transaction((txn) async {
    List<Map<String, dynamic>> maps = await txn.query("task",
        where: "task_name = ?", whereArgs: [taskHistory.taskName]);

    var taskId = null;
    if (maps.isEmpty) {
      var task = Task(
          taskName: taskHistory.taskName,
          status: 1,
          createTime: DateTime.now());
      int c = await txn.insert("task", task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("inserted1: $c");
      taskId = c;
    } else {
      taskId = maps.first["id"];

      txn.update("task", {"status": 1}, where: "id = ?", whereArgs: [taskId]);
    }

    taskHistory.taskId = taskId;
    var historyId = await txn.insert(
      "task_history",
      taskHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    taskHistory.id = historyId;

    return taskHistory;
  });

  return t;
}

Future<bool> updateTaskHistory(TaskHistory? taskHistory, int taskStatus) async {
  print("更新任务");
  var db = await DatabaseHelper.internal().db;
  var i = await db.transaction((txn) async {
    txn.update("task", {'status': taskStatus},
        where: "id = ?", whereArgs: [taskHistory!.taskId]);

    var i = await txn.update("task_history", taskHistory!.toMap(),
        where: "id = ?", whereArgs: [taskHistory.id]);

    return i;
  });
  return i > 0;
}

Future<TaskHistory?> lastTaskHistory() async {
  print("搜索最后一个任务");
  var db = await DatabaseHelper.internal().db;

  List<Map<String, dynamic>> maps = await db.query("task_history",
      where: "end_time is null", orderBy: "start_time desc", limit: 1);

  if (maps.isEmpty) {
    return null;
  } else {
    TaskHistory t = TaskHistory.fromMap(maps.first);
    return t;
  }
}

Future<List<TaskHistory>> getTaskHistoryList(int taskId) async {
  var db = await DatabaseHelper.internal().db;
  List<Map<String, dynamic>> maps = await db.query("task_history",
      where: "task_id = ?", orderBy: "start_time desc ", whereArgs: [taskId]);
  if (maps.isEmpty) {
    return [];
  } else {
    List<TaskHistory> tasks =
        List<TaskHistory>.from(maps.map((map) => TaskHistory.fromMap(map)));
    return tasks;
  }
}

/**
 * 是否能够恢复任务
 */
Future<bool> canRestored() async {
  var db = await DatabaseHelper.internal().db;
  var t = await lastTaskHistory();
  return t == null;
}

Future<bool> restoreTask(Task task) async {
  var db = await DatabaseHelper.internal().db;

  db.transaction((txn) async {
    txn.update("task", {"status": 1}, where: "id = ?", whereArgs: [task.id]);

    TaskHistory taskHistory = TaskHistory(
        taskId: task.id, taskName: task.taskName, startTime: DateTime.now());
    var historyId = await txn.insert(
      "task_history",
      taskHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  });
  return true;
}