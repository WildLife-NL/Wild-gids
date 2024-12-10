import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wildgids/app.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildgids/services/animal.dart';
import 'package:wildgids/services/isar/helpers/isar_db.dart';
import 'package:workmanager/workmanager.dart';
import 'package:wildlife_api_connection/models/isar/isar_animal_tracking.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case Workmanager.iOSBackgroundTask:
        stderr.writeln("The iOS background fetch was triggered");
        break;
      case "getallanimals-task-identifier":
        stderr.writeln("getallanimals task was triggered");
        try {
          final isar = IsarDB.shared.instance;
          isar.isarAnimalTrackings.clear();
          final animalTrackings = await AnimalService().getAllAnimalTrackings();

          for (final animalTracking in animalTrackings) {
            final isarAnimalTracking = IsarAnimalTracking.fromAnimalTracking(
                animalTracking, isar.isarAnimalTrackings.autoIncrement());
            isar.isarAnimalTrackings.put(isarAnimalTracking);
          }
        } catch (e) {
          stderr.writeln("getallanimals task failed: $e");
        }

        break;
    }
    bool success = true;
    return Future.value(success);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  await dotenv.load(fileName: ".env");
  PackageInfo info = await PackageInfo.fromPlatform();
  AppConfig.create(flavor: getFlavorByPackageName(info.packageName));

  await IsarDB.shared.init();
  runApp(const App());
}
