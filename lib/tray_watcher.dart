import 'dart:io';

import "package:tray_manager/tray_manager.dart";
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TrayWatcher extends StatefulWidget {
  final Widget child;

  const TrayWatcher({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _TrayWatcherStates( child: child);
}

class _TrayWatcherStates extends State<TrayWatcher> with TrayListener {
  final Widget child;

  _TrayWatcherStates({ required this.child});


  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() async {
    //   左键点击打开菜单
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case "open":
        print("打开应用");
        break;
      case "quite":
        print("退出应用");
        exit(0);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
