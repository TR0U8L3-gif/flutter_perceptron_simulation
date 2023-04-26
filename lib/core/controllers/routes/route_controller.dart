import 'package:get/get.dart';
import 'package:perceptron_simulation/core/views/main_screen.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';


class RouteController extends GetxController {
  static RouteController instance = Get.find();

  //init
  static const String _mainRoute = "/main";

  //init route
  String get getMainRoute => _mainRoute;

  List<GetPage> routes = [
    GetPage(
        name: _mainRoute,
        page: () => const MainScreen(),
        transition: Transition.fadeIn,
        transitionDuration: duration1200),
  ];

}