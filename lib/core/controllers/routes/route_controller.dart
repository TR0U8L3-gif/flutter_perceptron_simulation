import 'package:get/get.dart';
import 'package:perceptron_simulation/core/views/data_info_screen.dart';
import 'package:perceptron_simulation/core/views/load_example_data_screen.dart';
import 'package:perceptron_simulation/core/views/main_screen.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';


class RouteController extends GetxController {
  static RouteController instance = Get.find();

  //init
  static const String _mainRoute = "/main";
  static const String _dataInfoRoute = "/info";
  static const String _loadExampleDataRoute = "/loadExampleData";

  //init route
  String get getMainRoute => _mainRoute;
  String get getInfoRoute => _dataInfoRoute;
  String get getLoadExampleDataRoute => _loadExampleDataRoute;

  List<GetPage> routes = [
    GetPage(
        name: _mainRoute,
        page: () => MainScreen(),
        transition: Transition.fadeIn,
        transitionDuration: duration1200,
    ),
    GetPage(
      name: _dataInfoRoute,
      page: () => DataInfoScreen(),
      transition: Transition.fadeIn,
      transitionDuration: duration400,
    ),
    GetPage(
      name: _loadExampleDataRoute,
      page: () => const LoadExampleDataScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: duration400,
    ),
  ];

}