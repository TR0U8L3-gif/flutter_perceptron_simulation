import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';

class PerceptronEditorScreen extends StatefulWidget {
  const PerceptronEditorScreen({Key? key}) : super(key: key);

  @override
  State<PerceptronEditorScreen> createState() => _PerceptronEditorScreenState();
}

class _PerceptronEditorScreenState extends State<PerceptronEditorScreen> {
  final SimulationController simulationController = Get.find();
  double learningRate = 0.1;
  List<ActivationFunction> activationFunctions = [
    StepFunction(),
    BipolarStepFunction(),
    SigmoidFunction(),
    ReluFunction(),
    TanhFunction(),
    SoftMaxFunction(),
  ];
  ActivationFunction activationFunction = SigmoidFunction();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Obx(() {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  chooseActivationFunctionWidget(),
                  const SizedBox(
                    height: 128,
                  ),
                  learningRateWidget(),
                  const SizedBox(
                    height: 32,
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
                              min(size.width, size.height) * 0.2) -
                              48 -
                              12
                              : (size.width -
                              min(size.width, size.height) * 0.2),
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
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
                          //TODO: simulation visualization
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
                              borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
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
          ),
          appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
        ),
      );
    });
  }

  chooseActivationFunctionWidget() =>
      Column(children: [
        const Text(
          "Select perceptron activation function",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Opacity(
            opacity: 0.9,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: const Text(
                "This parameter transforms the input signal of a perceptron model into an output signal.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // child: ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: activationFunctions.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 12),
              //       child: InkWell(
              //         borderRadius: const BorderRadius.all(Radius.circular(32)),
              //         onTap: () => activationFunction = activationFunctions[index],
              //         child: Container(
              //           height: 48,
              //           decoration: BoxDecoration(
              //             borderRadius: const BorderRadius.all(Radius.circular(32)),
              //             color: ColorProvider.isThemeDark(context)
              //                 ? ColorProvider.yellowDark
              //                 : ColorProvider.yellowLight,
              //           ),
              //           alignment: Alignment.center,
              //           child: Text(
              //             activationFunctions[index].name,
              //             style: TextStyle(
              //                 color: ColorProvider.isThemeDark(context)
              //                     ? ColorProvider.dark
              //                     : ColorProvider.light,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {},
              child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    color: (ColorProvider.isThemeDark(context)
                        ? ColorProvider.light
                        : ColorProvider.dark)
                        .withOpacity(0.24),
                  ),
                  alignment: Alignment.center,
                  child: const Text("Clear")),
            ),
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {
                if (simulationController.perceptron == null) return;
                setState(() {
                  simulationController.perceptron!.activationFunction = activationFunction;
                });
              },
              child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      color: (ColorProvider.isThemeDark(context)
                          ? ColorProvider.yellowDark
                          : ColorProvider.yellowLight)
                          .withOpacity(0.72)),
                  alignment: Alignment.center,
                  child: const Text("Accept")),
            ),
          ],
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Text(
              simulationController.perceptron == null
                  ? "..."
                  : "Perceptron activation function set to\n${simulationController
                  .perceptron!.activationFunction.name}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);

  learningRateWidget() =>
      Column(children: [
        const Text(
          "Select perceptron learning rate",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Opacity(
            opacity: 0.9,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: const Text(
                "This parameter controls the speed and accuracy of the learning process.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                onTap: () {
                  if (learningRate <= 0.01) return;
                  setState(() {
                    learningRate = roundDouble(learningRate - 0.01, 2);
                  });
                },
                child: Container(
                  width: 56,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    color: ColorProvider.isThemeDark(context)
                        ? ColorProvider.yellowDark
                        : ColorProvider.yellowLight,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "-0.01",
                    style: TextStyle(
                        color: ColorProvider.isThemeDark(context)
                            ? ColorProvider.dark
                            : ColorProvider.light,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text(
                learningRate.toStringAsFixed(2),
                style:
                const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                onTap: () {
                  if (learningRate >= 2) return;
                  setState(() {
                    learningRate = roundDouble(learningRate + 0.01, 2);
                  });
                },
                child: Container(
                  width: 56,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    color: ColorProvider.isThemeDark(context)
                        ? ColorProvider.yellowDark
                        : ColorProvider.yellowLight,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "+0.01",
                    style: TextStyle(
                        color: ColorProvider.isThemeDark(context)
                            ? ColorProvider.dark
                            : ColorProvider.light,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Slider(
            min: 0.01,
            max: 2,
            thumbColor: ColorProvider.isThemeDark(context)
                ? ColorProvider.yellowDark
                : ColorProvider.yellowLight,
            value: learningRate,
            onChanged: (double value) =>
                setState(() {
                  learningRate = roundDouble(value, 2);
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {
                setState(() {
                  learningRate = 0.1;
                });
                if(simulationController.perceptron == null) return;
                simulationController.perceptron!.learningRate = 0.1;
              },
              child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    color: (ColorProvider.isThemeDark(context)
                        ? ColorProvider.light
                        : ColorProvider.dark)
                        .withOpacity(0.24),
                  ),
                  alignment: Alignment.center,
                  child: const Text("Clear")),
            ),
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {
                if (simulationController.perceptron == null) return;
                setState(() {
                  simulationController.perceptron!.learningRate = learningRate;
                });
              },
              child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      color: (ColorProvider.isThemeDark(context)
                          ? ColorProvider.yellowDark
                          : ColorProvider.yellowLight)
                          .withOpacity(0.72)),
                  alignment: Alignment.center,
                  child: const Text("Accept")),
            ),
          ],
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Text(
              simulationController.perceptron == null
                  ? "..."
                  : "Perceptron learning rate set to ${simulationController
                  .perceptron!.learningRate}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: double.infinity,
            alignment: Alignment.topCenter,
            child: Text(
              learningRate < 1
                  ? "lower learning rate can improve stability, but it may also result in slower convergence"
                  : "higher learning rate can lead to faster convergence, but it may also cause instability",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);
}
