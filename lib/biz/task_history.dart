class TaskHistory {
  int? id;
  String taskName;
  String? taskCode;
  DateTime startTime;
  DateTime? endTime;
  int? taskId;

  // 构造函数
  TaskHistory({
    this.id,
    required this.taskName,
    this.taskCode,
    required this.startTime,
    this.endTime,
    this.taskId,
  });

  // 计算时间差
  Duration timeDiff() {
    DateTime currentTime = DateTime.now();
    Duration timeDifference = currentTime.difference(startTime);
    return timeDifference;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  String timeDiffShow() {
    return formatDuration(timeDiff());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': taskName,
      'task_code': taskCode,
      'task_id': taskId,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime?.millisecondsSinceEpoch,
    };
  }

  factory TaskHistory.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return TaskHistory(id: -1, taskName: "-", startTime: DateTime.now());
    }
    return TaskHistory(
      id: map['id'],
      taskName: map['task_name'],
      taskCode: map['task_code'],
      taskId: map['task_id'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time']),
      endTime: map['end_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_time'])
          : null,
    );
  }
}
