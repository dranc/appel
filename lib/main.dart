import 'package:appel/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://bfad4ce0116cca066f8730f6a9fcbf3a@o4507715408691200.ingest.de.sentry.io/4507715413016656';
      options.tracesSampleRate = 0.5;
      options.profilesSampleRate = 0.5;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 139, 0, 0)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
    );
  }
}
