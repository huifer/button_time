import "package:tray_manager/tray_manager.dart";

// 初始化系统托盘
Future<void> initSystemTray() async {
//   设置系统托盘图标
  await trayManager.setIcon(
    "assets/icons8-时钟-50.png",
  );
  List<MenuItem> items = [
    MenuItem(
      label: "打开",
      key: "open",
    ),
    MenuItem(
      label: "退出",
      key: "quite",
    ),
  ];
  await trayManager.setContextMenu(Menu(items: items));
}
