import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';

class PerceptronSimulationScreen extends StatefulWidget {
  const PerceptronSimulationScreen({Key? key}) : super(key: key);

  @override
  State<PerceptronSimulationScreen> createState() => _PerceptronSimulationScreenState();
}

class _PerceptronSimulationScreenState extends State<PerceptronSimulationScreen> {
  final SimulationController simulationController = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(

            ),
          ),
          appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
        ),
      );
    });
  }
}
