import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wildgids/app.dart';
import 'package:wildgids/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  PackageInfo info = await PackageInfo.fromPlatform();
  AppConfig.create(flavor: getFlavorByPackageName(info.packageName));
  runApp(const App());
}
