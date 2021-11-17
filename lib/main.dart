import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'models/history_entry.dart';
import 'providers/file_manager.dart';
import 'providers/file_uploader.dart';
import 'screens/about_screen.dart';
import 'screens/error_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/uploaded_screen.dart';
import 'screens/uploading_screen.dart';

void main() async {
  /// Sets navigation bar to white.
  ///
  /// Checkout styles.xml in android/app/src/main/res folder
  /// for white color in status bar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFAFAFA),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  /// Hive database initialization and adapt class for its usage.
  /// https://docs.hivedb.dev/#/custom-objects/type_adapters.
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryEntryAdapter());
  await Hive.openBox<HistoryEntry>('history');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileManager()),
        ChangeNotifierProvider(create: (context) => FileUploader()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        title: 'VoidShare',
        home: const HomeScreen(),

        /// Necessary for page transition,
        /// https://pub.dev/packages/page_transition.
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case HistoryScreen.routeName:
              return PageTransition(
                child: const HistoryScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case UploadedScreen.routeName:
              return PageTransition(
                child: const UploadedScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case UploadingScreen.routeName:
              return PageTransition(
                child: const UploadingScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case ErrorScreen.routeName:
              return PageTransition(
                child: const ErrorScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case AboutScreen.routeName:
              return PageTransition(
                child: const AboutScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
