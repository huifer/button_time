import 'dart:async';

import 'package:flutter/material.dart';

import 'biz/task_history.dart';
import 'biz/task_history_service.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late DateTime dateTime;

  late TaskHistory? curTaskHistory;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    curTaskHistory = null;
    init();

    _timer = Timer.periodic(const Duration(seconds: 1), setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// 获取当前执行任务名称
  Future<TaskHistory?> getCurTask() async {

    return lastTaskHistory();

  }

  // 1. 先确认是否有任务
  // 1.1 如果有任务则获取任务展示
  // 1.2 如果没有任务按钮则为绿色背景

  void init() async {
    getCurTask().then((value) => curTaskHistory = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "当前任务: ${curTaskHistory?.taskName ?? ""} 耗时: ",
                  style: const TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  curTaskHistory != null ? "${curTaskHistory?.timeDiffShow()}" : "",
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Material(
              shape: const CircleBorder(),
              child: buildIconButton(),
            )
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
      onPressed: () {
        if (curTaskHistory == null) {
          // 开始任务
          print("开始任务");
          _showInputDialog();

        } else {
          // 结束任务
          print("停止任务");
          curTaskHistory?.endTime = DateTime.now();
          _showConfirmationDialog();
        }
      },
      icon: curTaskHistory == null
          ? const Icon(Icons.play_circle)
          : const Icon(Icons.stop_circle),
      iconSize: 100,
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: AlertDialog(
            title: Text("请选择任务状态："),
            contentPadding: EdgeInsets.all(10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _handleTaskCompletion();
                      },
                      child: Text("完成"),
                    ),
                    SizedBox(width: 16.0), // 添加水平间距
                    ElevatedButton(
                      onPressed: () {
                        _handleTaskInterruption();
                      },
                      child: Text("打断"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTaskCompletion() {
    curTaskHistory?.endTime = DateTime.now();
    updateTaskHistory(curTaskHistory,2);
    Navigator.pop(context); // 关闭对话框
    curTaskHistory = null;
  }

  void _handleTaskInterruption() {
    curTaskHistory?.endTime = DateTime.now();
    updateTaskHistory(curTaskHistory,3);
    Navigator.pop(context); // 关闭对话框
    curTaskHistory = null;
  }

  TextEditingController _textEditingController = TextEditingController();

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('任务名称'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: '请输入任务名称'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _textEditingController.clear();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 这里获取输入的文本
                String enteredText = _textEditingController.text;
                print('Entered Text: $enteredText');
                Navigator.pop(context);
                curTaskHistory = await saveTaskHistory(TaskHistory(
                    taskName: enteredText,
                    taskCode: null,
                    startTime: DateTime.now(),
                    endTime: null));
                _textEditingController.clear();

              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }
}
