import 'package:get/get.dart';
import 'package:perceptron_simulation/core/views/data_info_screen.dart';
import 'package:perceptron_simulation/core/views/data_split_screen.dart';
import 'package:perceptron_simulation/core/views/data_load_screen.dart';
import 'package:perceptron_simulation/core/views/main_screen.dart';
import 'package:perceptron_simulation/core/views/perceptron_editor_screen.dart';
import 'package:perceptron_simulation/core/views/perceptron_simulation_screen.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';


class RouteController extends GetxController {
  static RouteController instance = Get.find();

  //init
  static const String _mainRoute = "/main";
  static const String _dataInfoRoute = "/info";
  static const String _loadDataRoute = "/loadData";
  static const String _dataSplittingRoute = "/dataSplitting";
  static const String _perceptronEditorRoute = "/perceptronEditor";
  static const String _perceptronSimulationRoute = "/perceptronSimulation";

  //init route
  String get getMainRoute => _mainRoute;
  String get getInfoRoute => _dataInfoRoute;
  String get getLoadDataRoute => _loadDataRoute;
  String get getDataSplittingRoute=> _dataSplittingRoute;
  String get getPerceptronEditorRoute=> _perceptronEditorRoute;
  String get getPerceptronSimulationRoute=> _perceptronSimulationRoute;

  List<GetPage> routes = [
    GetPage(
        name: _mainRoute,
        page: () => const MainScreen(),
        transition: Transition.fadeIn,
        transitionDuration: duration600,
    ),
    GetPage(
      name: _dataInfoRoute,
      page: () => DataInfoScreen(),
      transition: Transition.fadeIn,
      transitionDuration: duration400,
    ),
    GetPage(
      name: _loadDataRoute,
      page: () => LoadDataScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: duration400,
    ),
    GetPage(
      name: _dataSplittingRoute,
      page: () => const DataSplittingScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: duration400,
    ),
    GetPage(
      name: _perceptronEditorRoute,
      page: () => const PerceptronEditorScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: duration400,
    ),
    GetPage(
      name: _perceptronSimulationRoute,
      page: () => const PerceptronSimulationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: duration400,
    ),
  ];

}