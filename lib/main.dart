import 'package:button_time/tray_utils.dart';
import 'package:button_time/tray_watcher.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'MyApp.dart';
import 'biz/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() async {

  runApp(const MyApp());
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await  DatabaseHelper().initDb();
  await initSystemTray();

}
