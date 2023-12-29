import 'package:button_time/biz/task_history_service.dart';
import 'package:button_time/biz/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'TaskDetailsPage.dart';
import 'biz/Task.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: taskListStorage.isEmpty
          ? const Center(child: Text('没有任务'))
          : ListView.builder(
              itemCount: taskListStorage.length,
              itemBuilder: (context, index) {
                Task task = taskListStorage[index];

                String formattedCreateTime = task.createTime != null
              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(task.createTime!)
              : '';

                TextSpan statusSpan = TextSpan(
                  text: '任务状态: ${task.convStatus(task.status)}',
                  style: TextStyle(
                    color: _getStatusColor(task.status),
                  ),
                );

          bool isInterrupted = task.status == 3;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                // 处理点击事件，您可以在这里访问task对象
                print("Clicked on task: ${task.taskName}");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskItem(
                    task: task,
                    formattedCreateTime: formattedCreateTime,
                    statusSpan: statusSpan,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  late List<Task> taskListStorage = [];

  @override
  void initState() {
    super.initState();
    loadTaskList();
  }

  Future<void> loadTaskList() async {
    taskListStorage = await taskList();
    // 通知框架重新构建UI
    if (mounted) {
      setState(() {});
    }
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    Key? key,
    required this.task,
    required this.formattedCreateTime,
    required this.statusSpan,
  }) : super(key: key);

  final Task task;
  final String formattedCreateTime;
  final TextSpan statusSpan;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          _handleTaskItemClick(context);
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        splashColor: _getBackgroundColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧展示任务时间
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.taskName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('创建时间: $formattedCreateTime'),
                  ),
                ],
              ),
              // 右侧展示状态和按钮
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: DefaultTextStyle.of(context).style,
                            ),
                            statusSpan,
                          ],
                        ),
                      ),
                      if (task.status == 3)
                        Column(

                          children: [
                            SizedBox(height: 4.0), // 调整间距
                            ElevatedButton(
                              onPressed: () async {
                                // 处理按钮点击事件
                                print(
                                    "Button clicked for interrupted task: ${task.id}");
                                var c = await canRestored();
                                if (c) {
                                  // 恢复任务
                                  await restoreTask(task);
                                } else {
                                  // 不能点击
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("提示"),
                                        content: Text("当前有任务正在进行，不能恢复"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 关闭对话框
                                            },
                                            child: Text("确定"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text('恢复打断'),
                            ),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTaskItemClick(BuildContext context) {
    print("Clicked on task: ${task.taskName}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.lightBlue.shade100;
    } else {
      return Colors.blue.shade800;
    }
  }
}

Color _getStatusColor(int? status) {
  // 根据不同的任务状态返回不同的颜色
  switch (status) {
    case 1: // 进行中
      return Colors.blue;
    case 2: // 已完成
      return Colors.green;
    case 3: // 被打断
      return Colors.red;
    default:
      return Colors.black; // 其他状态
  }
}
