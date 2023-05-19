import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';

class PerceptronSimulationScreen extends StatefulWidget {
  const PerceptronSimulationScreen({Key? key}) : super(key: key);

  @override
  State<PerceptronSimulationScreen> createState() =>
      _PerceptronSimulationScreenState();
}

class _PerceptronSimulationScreenState
    extends State<PerceptronSimulationScreen> {
  final SimulationController simulationController = Get.find();

  @override
  void initState() {
    if (simulationController.perceptron == null) {
      Get.offAllNamed(routeController.getMainRoute);
    }
    simulationController.initSimulation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          Get.toNamed(routeController.getMainRoute);
          return false;
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Opacity(
                    opacity: simulationController.isSimulationAdding ? 0.5 : 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.isSimulationAdding || simulationController.isSimulating) return;
                            setState(() {
                              simulationController.restartSimulation();
                            });
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulating ? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(32)),
                                  color: (ColorProvider.isThemeDark(context)
                                          ? ColorProvider.light
                                          : ColorProvider.dark)
                                      .withOpacity(0.24),
                                ),
                                alignment: Alignment.center,
                                child: const Text("Restart")),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.isSimulationAdding) return;
                            simulationController.stopSimulation();
                          },
                          child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                color: (!simulationController.isSimulationPlaying
                                        ? (ColorProvider.isThemeDark(context)
                                            ? ColorProvider.yellowDark
                                            : ColorProvider.yellowLight)
                                        : (ColorProvider.isThemeDark(context)
                                            ? ColorProvider.light
                                            : ColorProvider.dark))
                                    .withOpacity(
                                        !simulationController.isSimulationPlaying
                                            ? 0.48
                                            : 0.24),
                              ),
                              alignment: Alignment.center,
                              child: const Text("Stop")),
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.isSimulationAdding || simulationController.isSimulating) {
                              return;
                            }
                            simulationController.startSimulation();
                          },
                          child: Opacity(
                            opacity:simulationController.isSimulationAdding || simulationController.isSimulating ? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(32)),
                                  color: (simulationController.isSimulationPlaying
                                          ? (ColorProvider.isThemeDark(context)
                                              ? ColorProvider.yellowDark
                                              : ColorProvider.yellowLight)
                                          : (ColorProvider.isThemeDark(context)
                                              ? ColorProvider.light
                                              : ColorProvider.dark))
                                      .withOpacity(
                                          simulationController.isSimulationPlaying
                                              ? 0.48
                                              : 0.24),
                                ),
                                alignment: Alignment.center,
                                child: const Text("Start")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text("Animation speed")),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 36,
                                width: 64,
                                alignment: Alignment.center,
                                child: Text(
                                  "x${simulationController.simulationSpeed.toStringAsFixed(1)}",
                                  style: const TextStyle(fontSize: 24),
                                )),
                            Expanded(
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                child: Slider(
                                  min: 0,
                                  max: 10.0,
                                  thumbColor:
                                  ColorProvider.isThemeDark(context)
                                      ? ColorProvider.yellowDark
                                      : ColorProvider.yellowLight,
                                  value: simulationController.simulationSpeed.toDouble(),
                                  onChanged: (double value) => setState(() {
                                    simulationController..simulationSpeed = roundDouble(value, 1);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.perceptron == null) return;
                            if(simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(epochs: 1);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                                  color: (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark)
                                      .withOpacity(0.24),
                                ),
                                alignment: Alignment.center,
                                child: const Text("add epoch")),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.perceptron == null) return;
                            if(simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(epochs: 5);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating ? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                                  color: (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark)
                                      .withOpacity(0.24),
                                ),
                                alignment: Alignment.center,
                                child: const Text("add 5 epochs")),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            if(simulationController.perceptron == null) return;
                            if(simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(epochs: 25);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying || simulationController.isSimulationAdding || simulationController.isSimulating ? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                                  color: (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark)
                                      .withOpacity(0.24),
                                ),
                                alignment: Alignment.center,
                                child: const Text("add 25 epochs")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GetBuilder<SimulationController>(builder: (_) => Text(simulationController.perceptron.toString()),),
                ],
              ),
            ),
          ),
          appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
        ),
      );
    });
  }
}
