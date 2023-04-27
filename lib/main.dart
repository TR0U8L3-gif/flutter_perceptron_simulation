import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/core/controllers/routes/route_controller.dart';
import 'package:perceptron_simulation/core/views/main_screen.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(RouteController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Perceptron Simulator',
      themeMode: ThemeMode.system,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: routeController.getMainRoute,
      getPages: routeController.routes,
      home: MainScreen(),
    );
  }
}
