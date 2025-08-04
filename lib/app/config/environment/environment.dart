import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get environmentConfig {
    if (kReleaseMode) {
      return 'lib/app/config/environment/.env-prod';
    }

    return 'lib/app/config/environment/.env-dev';
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? "Undefined API_URL";
  }
}
