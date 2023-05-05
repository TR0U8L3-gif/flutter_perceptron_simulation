import 'package:fl_chart/fl_chart.dart';
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
    final size = MediaQuery.of(context).size;
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
                    height: 32,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                        border: Border.all(
                          width: 2,
                          color: (ColorProvider.isThemeDark(context)
                              ? ColorProvider.light
                              : ColorProvider.dark),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 0),
                      child: chooseActivationFunctionWidget(size),
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                        border: Border.all(
                          width: 2,
                          color: (ColorProvider.isThemeDark(context)
                              ? ColorProvider.light
                              : ColorProvider.dark),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      child: learningRateWidget(),
                    ),
                  ),
                  const SizedBox(
                    height: 64,
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
                  const SizedBox(
                    height: 16,
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

  chooseActivationFunctionWidget(Size size) => Column(children: [
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
          height: 56,
          width: size.width,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              color: (ColorProvider.isThemeDark(context)
                      ? ColorProvider.light
                      : ColorProvider.dark)
                  .withOpacity(0.16),
            ),
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: activationFunctions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right:
                            index != activationFunctions.length - 1 ? 12 : 0),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      onTap: () => setState(() {
                        activationFunction = activationFunctions[index];
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                          color: activationFunctions[index].name ==
                                  activationFunction.name
                              ? ColorProvider.isThemeDark(context)
                                  ? ColorProvider.yellowLight
                                  : ColorProvider.yellowDark
                              : ColorProvider.isThemeDark(context)
                                  ? ColorProvider.yellowDark
                                  : ColorProvider.yellowLight,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Text(
                          activationFunctions[index].name,
                          style: TextStyle(
                              color: ColorProvider.isThemeDark(context)
                                  ? ColorProvider.dark
                                  : ColorProvider.light,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            width: size.width,
            padding: const EdgeInsets.all(20),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                color: (ColorProvider.isThemeDark(context)
                        ? ColorProvider.light
                        : ColorProvider.dark)
                    .withOpacity(0.16),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, right: 32),
                  child: IgnorePointer(
                    child: LineChart(
                      LineChartData(
                        minX: -5,
                        maxX: 5,
                        minY: activationFunction.min ?? -5,
                        maxY: activationFunction.max ?? 5,
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: ((activationFunction.max ?? 5) -
                                      (activationFunction.min ?? -5)) /
                                  4,
                              reservedSize: 36,
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          verticalInterval: 1,
                          horizontalInterval: ((activationFunction.max ?? 5) -
                                  (activationFunction.min ?? -5)) /
                              4,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark)
                                  .withOpacity(0.48),
                              strokeWidth: 1.6,
                            );
                          },
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark)
                                  .withOpacity(0.36),
                              strokeWidth: 1.6,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            barWidth: 6,
                            dotData: FlDotData(
                              show: false,
                            ),
                            spots: getFunctionPoints(
                                activationFunction: activationFunction,
                                minX: -5,
                                maxX: 5),
                            gradient: LinearGradient(
                                colors: ColorProvider.isThemeDark()
                                    ? [
                                        ColorProvider.blueDark,
                                        ColorProvider.greenDark
                                      ]
                                    : [
                                        ColorProvider.blueLight,
                                        ColorProvider.greenLight
                                      ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.5, 0.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
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
                  activationFunction = SigmoidFunction();
                });
                if (simulationController.perceptron == null) return;
                simulationController.perceptron!.activationFunction =
                    SigmoidFunction();
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
                  simulationController.perceptron!.activationFunction =
                      activationFunction;
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
                  : "Perceptron activation function set to\n${simulationController.perceptron!.activationFunction.name}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);

  learningRateWidget() => Column(children: [
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
            onChanged: (double value) => setState(() {
              learningRate = roundDouble(value, 2);
            }),
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        const SizedBox(
          height: 16,
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
                if (simulationController.perceptron == null) return;
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
                  : "Perceptron learning rate set to ${simulationController.perceptron!.learningRate}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);
}

List<FlSpot> getFunctionPoints(
    {required ActivationFunction activationFunction,
    required double minX,
    required double maxX}) {
  List<FlSpot> result = [];
  for (double i = minX; i <= maxX; i += 0.1) {
    result
        .add(FlSpot(i.toDouble(), activationFunction.calculate(i.toDouble())));
  }
  return result;
}
