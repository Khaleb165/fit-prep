import 'package:fit_prep/view/home_screen.dart';
import 'package:fit_prep/view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/checklist_provider.dart';
import 'view_model/plan_provider.dart';
import 'core/services/notification_service.dart';
import 'data/offline/hive.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HiveStorage storage = HiveStorage.instance;
  await storage.init();
  await NotificationService.instance.init();

  runApp(
    MainApp(
      showWelcomePage: storage.getIsFirstTime(),
      storage: storage,
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    required this.showWelcomePage,
    required this.storage,
    super.key,
  });

  final bool showWelcomePage;
  final HiveStorage storage;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.ensurePermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChecklistProvider(storage: widget.storage),
        ),
        ChangeNotifierProvider(
          create: (_) => PlanProvider(storage: widget.storage),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: widget.showWelcomePage ? const WelcomePage() : const HomePage(),
      ),
    );
  }
}
