import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'models/history_entry.dart';
import 'providers/file_manager.dart';
import 'providers/file_uploader.dart';
import 'screens/error_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/uploaded_screen.dart';
import 'screens/uploading_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFAFAFA),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
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
