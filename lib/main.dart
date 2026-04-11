import 'package:fit_prep/view/home_screen.dart';
import 'package:fit_prep/view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/checklist_provider.dart';
import 'data/offline/hive.dart';
import 'core/utils/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HiveStorage storage = HiveStorage.instance;
  await storage.init();

  runApp(
    MainApp(
      showWelcomePage: storage.getIsFirstTime(),
      storage: storage,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    required this.showWelcomePage,
    required this.storage,
    super.key,
  });

  final bool showWelcomePage;
  final HiveStorage storage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChecklistProvider(storage: storage),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: showWelcomePage ? const WelcomePage() : const HomePage(),
      ),
    );
  }
}
