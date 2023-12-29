class Task {
  // 主键
  int? id;

  // 任务名称
  String taskName;

  // 任务状态 1: 进行中，2: 已完成，3： 被打断
  int? status;
  String? statusNote;
  DateTime? createTime;

  Task({this.id, required this.taskName, this.status, this.createTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': taskName,
      'status': status,
      "create_time": DateTime.now().millisecondsSinceEpoch
    };
  }

  factory Task.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return Task(id: -1, taskName: "-", createTime: DateTime.now());
    }
    return Task(
      id: map['id'],
      taskName: map['task_name'],
      status: map['status'],
        createTime: map['create_time'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['create_time']));
  }

  String convStatus(status) {
    if (status == 1) {
      return "进行中";
    } else if (status == 2) {
      return "已完成";
    } else if (status == 3) {
      return "被打断";
    }
    return "未知状态";
  }
}
