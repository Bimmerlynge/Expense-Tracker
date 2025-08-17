import 'package:expense_tracker/auth_gate.dart';
import 'package:expense_tracker/startup_gate.dart';
import 'package:expense_tracker/version_resolver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/config/environment/environment.dart';
import 'app/config/theme/app_theme.dart';
import 'app/network/mock/mock_dio_setup.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: Environment.environmentConfig);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // setupMockDio();
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mainTheme,
      home: const StartupGate(),
    );
  }
}
