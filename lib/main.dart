import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:litenews/ui/home_page.dart';
import 'package:litenews/ui/routes/page_manifest.dart';
import 'package:litenews/ui/routes/page_path.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
      initialRoute: PagePath.mMain,
      getPages: PageManifest.routes,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
