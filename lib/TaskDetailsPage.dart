import 'biz/Task.dart';
import 'package:button_time/biz/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'biz/task_history.dart';
import 'biz/task_history_service.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  TaskDetailsPage({required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  List<TaskHistory> taskHistoryList = [];

  @override
  void initState() {
    super.initState();
    loadTaskHistoryList();
  }

  Future<void> loadTaskHistoryList() async {
    List<TaskHistory> historyList =
        await getTaskHistoryList(widget.task.id ?? 0);
    setState(() {
      taskHistoryList = historyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务历史'),
      ),
      body: Center(
        child: taskHistoryList.isEmpty
            ? Text('暂无任务历史')
            : ListView.builder(
                itemCount: taskHistoryList.length,
                itemBuilder: (context, index) {
                  TaskHistory history = taskHistoryList[index];
                  String start_time = history.startTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(history.startTime!)
                      : '';
                  String end_time = history.endTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(history.endTime!)
                      : '';
                  return Card(
                    elevation: 2.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text('任务历史 ${index + 1}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('开始时间: ${start_time}'),
                          if (history.endTime != null)
                            Text('结束时间: ${end_time}'),
                          // 可以添加其他任务历史信息
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
