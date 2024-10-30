import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wildgids/models/enums/flavor.dart';
import 'package:wildlife_api_connection/api_client.dart';

Flavor getFlavorByPackageName(String packageName) {
  if (packageName == 'com.example.wildeBuren.development') {
    return Flavor.development;
  } else {
    //com.example.wildeBuren
    return Flavor.production;
  }
}

class AppConfig {
  ApiClient apiClient = ApiClient('');
  Flavor flavor = Flavor.production;
  String displayNameApp = 'Wildgids';

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({Flavor flavor = Flavor.production}) {
    switch (flavor) {
      case Flavor.development:
        return shared = AppConfig(
          flavor,
          ApiClient(dotenv.get('DEV_BASE_URL')),
          'Wildgids - Development',
        );
      case Flavor.production:
        return shared = AppConfig(
          flavor,
          ApiClient(dotenv.get('PROD_BASE_URL')),
          'Wildgids',
        );
    }
  }

  AppConfig(this.flavor, this.apiClient, this.displayNameApp);
}
