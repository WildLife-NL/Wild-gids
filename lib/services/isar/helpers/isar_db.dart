import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wildlife_api_connection/models/isar/isar_animal_tracking.dart';
import 'package:wildlife_api_connection/models/isar/isar_interaction.dart';

class IsarDB {
  IsarDB._privateConstructor();
  static final IsarDB _instance = IsarDB._privateConstructor();
  static IsarDB get shared => _instance;

  late Isar instance;

  init() async {
    instance = await Isar.open(
      [IsarInteractionSchema, IsarAnimalTrackingSchema],
      directory: (await getApplicationDocumentsDirectory()).path,
    );
  }
}
