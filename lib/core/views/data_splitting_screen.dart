import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';

class DataSplittingScreen extends StatefulWidget {
  const DataSplittingScreen({Key? key}) : super(key: key);

  @override
  State<DataSplittingScreen> createState() => _DataSplittingScreenState();
}

class _DataSplittingScreenState extends State<DataSplittingScreen> {
  final SimulationController simulationController = Get.find();
  int percentage = 60;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: (size.height - 500) / 2,
                  ),
                  SizedBox(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Separating the data into training and testing sets",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                onTap: () => setState(() {
                                  if (percentage <= 1) percentage = 100;
                                  percentage--;
                                }),
                                child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(32)),
                                      color: ColorProvider.isThemeDark(context)
                                          ? ColorProvider.yellowDark
                                          : ColorProvider.yellowLight,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.exposure_minus_1_rounded,
                                      color: ColorProvider.isThemeDark(context)
                                          ? ColorProvider.dark
                                          : ColorProvider.light,
                                    )),
                              ),
                              Text(
                                "$percentage%",
                                style: const TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                onTap: () => setState(() {
                                  if (percentage >= 99) percentage = 0;
                                  percentage++;
                                }),
                                child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(32)),
                                      color: ColorProvider.isThemeDark(context)
                                          ? ColorProvider.yellowDark
                                          : ColorProvider.yellowLight,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.exposure_plus_1_rounded,
                                      color: ColorProvider.isThemeDark(context)
                                          ? ColorProvider.dark
                                          : ColorProvider.light,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Slider(
                            min: 1.0,
                            max: 99.0,
                            thumbColor: ColorProvider.isThemeDark(context)
                                ? ColorProvider.yellowDark
                                : ColorProvider.yellowLight,
                            value: percentage.toDouble(),
                            onChanged: (double value) => setState(() {
                              percentage = value.toInt();
                            }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              onTap: () => setState(() {
                                simulationController.clearSets();
                                percentage = 60;
                              }),
                              child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32)),
                                    color: (ColorProvider.isThemeDark(context)
                                            ? ColorProvider.light
                                            : ColorProvider.dark)
                                        .withOpacity(0.24),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Clear")),
                            ),
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              onTap: () => simulationController.randomizeSets(
                                  percentage: percentage),
                              child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(32)),
                                      // gradient: LinearGradient(
                                      //     colors: ColorProvider.isThemeDark() ?  [ColorProvider.blueDark, ColorProvider.greenDark] : [ColorProvider.blueLight, ColorProvider.greenLight],
                                      //     begin: const FractionalOffset(0.0, 0.0),
                                      //     end: const FractionalOffset(0.5, 0.0),
                                      //     stops: const [0.0, 1.0],
                                      //     tileMode: TileMode.clamp
                                      // ),
                                      color: (ColorProvider.isThemeDark(context)
                                              ? ColorProvider.yellowDark
                                              : ColorProvider.yellowLight)
                                          .withOpacity(0.72)),
                                  alignment: Alignment.center,
                                  child: const Text("Accept")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Opacity(
                          opacity: 0.9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            width: double.infinity,
                            height: 52,
                            alignment: Alignment.bottomCenter,
                            child: AnimatedCrossFade(
                              firstChild: Text(
                                simulationController.trainingOutputData.isEmpty
                                    ? "..."
                                    : "Data has been split:\n ${simulationController.trainingOutputData.length} training ex. ${simulationController.predictOutputData.length} testing ex.",
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              secondChild: const Text(
                                "Select percentage by which the data will be divided into parts",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              crossFadeState: (simulationController
                                          .trainingOutputData.isNotEmpty &&
                                      simulationController
                                          .predictOutputData.isNotEmpty)
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: duration600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              onTap: () {
                                simulationController.cancel();
                                Get.offAllNamed(routeController.getMainRoute);
                              },
                              child: AnimatedContainer(
                                width: (simulationController
                                            .trainingOutputData.isNotEmpty &&
                                        simulationController
                                            .predictOutputData.isNotEmpty)
                                    ? (size.width -
                                            min(size.width, size.height) *
                                                0.2) -
                                        48 -
                                        12
                                    : (size.width -
                                        min(size.width, size.height) * 0.2),
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                  color: ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark,
                                ),
                                alignment: Alignment.center,
                                duration: duration600,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: ColorProvider.isThemeDark(context)
                                        ? ColorProvider.yellowDark
                                        : ColorProvider.yellowLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                                width: (simulationController
                                            .trainingOutputData.isNotEmpty &&
                                        simulationController
                                            .predictOutputData.isNotEmpty)
                                    ? 8
                                    : 0,
                                duration: duration400),
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              onTap: () {
                                //TODO: chose activation function
                              },
                              child: AnimatedContainer(
                                  width: (simulationController
                                              .trainingOutputData.isNotEmpty &&
                                          simulationController
                                              .predictOutputData.isNotEmpty)
                                      ? 48
                                      : 0,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32)),
                                    color: ColorProvider.isThemeDark(context)
                                        ? ColorProvider.yellowDark
                                        : ColorProvider.yellowLight,
                                  ),
                                  alignment: Alignment.center,
                                  duration: duration600,
                                  child: Icon(
                                    Icons.check,
                                    color: ColorProvider.isThemeDark(context)
                                        ? ColorProvider.dark
                                        : ColorProvider.light,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Data:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  IgnorePointer(
                    child: SizedBox(
                      width: size.width * 0.92,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Training Data:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  simulationController.trainingOutputData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "${simulationController.trainingInputData[index]} -> ${simulationController.trainingOutputData[index]}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  IgnorePointer(
                    child: SizedBox(
                      width: size.width * 0.92,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Test Data:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              simulationController.predictOutputData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "${simulationController.predictInputData[index]} -> ${simulationController.predictOutputData[index]}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
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
