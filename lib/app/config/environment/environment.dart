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

  static String get gitUrl {
    return dotenv.env['GIT_URL_DOWNLOAD'] ?? 'Undefined GIT_URL_DOWNLOAD';
  }

  static String get gitToken {
    return dotenv.env['AUTH_TOKEN'] ?? 'Undefined github token';
  }
}
