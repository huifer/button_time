import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SingDay.dart';

class SimpleCalendar extends StatefulWidget {
  @override
  _SimpleCalendarState createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日历图'),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                      1,
                    );
                  });
                },
              ),
              Text(
                DateFormat('yyyy-MM').format(_selectedDate),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                      1,
                    );
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
            child: Text('回到今天'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    List<String> weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    int numberOfWeeks =
        ((_daysInMonth(_selectedDate) + _selectedDate.weekday - 1) / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            return Text(
              weekDays[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          }),
        ),
        Table(
          border: TableBorder.all(color: Colors.white),
          children: List.generate(numberOfWeeks, (row) {
            return TableRow(
              children: List.generate(7, (col) {
                final dayOfMonth = (row * 7) + col - _selectedDate.weekday + 2;
                final currentDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  dayOfMonth,
                );

                Color cellColor = Colors.grey; // Default color for past dates

                if (currentDate.month == _selectedDate.month) {
                  if (currentDate.day == DateTime.now().day &&
                      currentDate.month == DateTime.now().month &&
                      currentDate.year == DateTime.now().year) {
                    cellColor = Colors.green; // Color for today
                  } else if (currentDate.isAfter(DateTime.now())) {
                    cellColor = Colors.blue; // Color for future dates
                  }
                }

                return TableCell(
                  child: GestureDetector(
                    onTap: () {
                      _handleCellTap(currentDate);
                    },
                    child: Opacity(
                      opacity: _cellBlinkStates.containsKey(currentDate) &&
                              _cellBlinkStates[currentDate]!
                          ? 0.5
                          : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: cellColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dayOfMonth > 0 &&
                                    dayOfMonth <= _daysInMonth(_selectedDate)
                                ? dayOfMonth.toString()
                                : '',
                            style: TextStyle(
                              color: currentDate.month == _selectedDate.month
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  bool _shouldBlink = false;

// 存储每个单元格是否应该闪烁的状态
  Map<DateTime, bool> _cellBlinkStates = {};

  void _handleCellTap(DateTime selectedDate) {
    setState(() {
      _cellBlinkStates[selectedDate] = true;
    });

    // 处理其他点击事件，例如打印所选日期
    print('Selected date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');

    // 在一定时间后停止闪烁效果
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _cellBlinkStates[selectedDate] = false;
      });
      // 导航到新页面
      _navigateToNewPage(selectedDate);
    });
  }

  void _navigateToNewPage(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPage(selectedDate: DateTime.now()),
      ),
    );
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
