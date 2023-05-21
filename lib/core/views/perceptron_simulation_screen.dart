import 'package:fl_chart/fl_chart.dart';
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
  bool isAnimationView = true;

  Color getColor(double value) {
    Color colorMax = Colors.green;
    Color colorMin = Colors.red;
    double minOpacity = 0.16;

    double maxValue = 4;
    double minValue = 0.1;
    if(value >= maxValue) {
      return colorMax;
    } else if(value <= -1 * maxValue) {
      return colorMin;
    } else if(value.abs() <= minValue) {
      return Colors.transparent;
    } else {
      double percentage = value.abs() / maxValue + minOpacity;
      if(percentage > 1) {
        percentage = 1;
      }
      if(value < 0){
        return colorMin.withOpacity(percentage);
      }
      else {
        return colorMax.withOpacity(percentage);
      }
    }

  }
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
    final size = MediaQuery
        .of(context)
        .size;
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
                  const SizedBox(
                    height: 32,
                  ),
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
                            if (simulationController.isSimulationAdding ||
                                simulationController.isSimulating) return;
                            setState(() {
                              simulationController.restartSimulation();
                            });
                          },
                          child: Opacity(
                            opacity:
                            simulationController.isSimulating ? 0.5 : 1,
                            child: Container(
                                height: 36,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
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
                            if (simulationController.isSimulationAdding) return;
                            simulationController.stopSimulation();
                          },
                          child: Container(
                              height: 36,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                                color: (!simulationController
                                    .isSimulationPlaying
                                    ? (ColorProvider.isThemeDark(context)
                                    ? ColorProvider.yellowDark
                                    : ColorProvider.yellowLight)
                                    : (ColorProvider.isThemeDark(context)
                                    ? ColorProvider.light
                                    : ColorProvider.dark))
                                    .withOpacity(!simulationController
                                    .isSimulationPlaying
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
                            if (simulationController.isSimulationAdding ||
                                simulationController.isSimulating) {
                              return;
                            }
                            simulationController.startSimulation();
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationAdding ||
                                simulationController.isSimulating
                                ? 0.5
                                : 1,
                            child: Container(
                                height: 36,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                  color: (simulationController
                                      .isSimulationPlaying
                                      ? (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.yellowDark
                                      : ColorProvider.yellowLight)
                                      : (ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark))
                                      .withOpacity(simulationController
                                      .isSimulationPlaying
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
                                  "x${simulationController.simulationSpeed
                                      .toStringAsFixed(1)}",
                                  style: const TextStyle(fontSize: 24),
                                )),
                            Expanded(
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                child: Slider(
                                  min: 0,
                                  max: 10.0,
                                  thumbColor: ColorProvider.isThemeDark(context)
                                      ? ColorProvider.yellowDark
                                      : ColorProvider.yellowLight,
                                  value: simulationController.simulationSpeed
                                      .toDouble(),
                                  onChanged: (double value) =>
                                      setState(() {
                                        simulationController
                                          ..simulationSpeed = roundDouble(
                                              value, 1);
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                            if (simulationController.perceptron == null) return;
                            if (simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(
                                epochs: 1);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating
                                ? 0.5
                                : 1,
                            child: Container(
                                height: 36,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
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
                            if (simulationController.perceptron == null) return;
                            if (simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(
                                epochs: 5);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating
                                ? 0.5
                                : 1,
                            child: Container(
                                height: 36,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
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
                            if (simulationController.perceptron == null) return;
                            if (simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating) return;
                            simulationController.perceptronTrainEpoch(
                                epochs: 25);
                          },
                          child: Opacity(
                            opacity: simulationController.isSimulationPlaying ||
                                simulationController.isSimulationAdding ||
                                simulationController.isSimulating
                                ? 0.5
                                : 1,
                            child: Container(
                                height: 36,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
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
                  GetBuilder<SimulationController>(
                    builder: (_) {
                      return Column(
                        children: [
                          const SizedBox(height: 4,),
                          AnimatedContainer(
                              width: size.width,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                                color: (ColorProvider.isThemeDark(context)
                                    ? ColorProvider.light
                                    : ColorProvider.dark)
                                    .withOpacity(0.16),
                              ),
                              duration: duration600,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        InkWell(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(32)),
                                          onTap: () =>
                                              setState(() {
                                                isAnimationView = true;
                                              }),
                                          child: Container(
                                              height: 24,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(32)),
                                                color: (ColorProvider
                                                    .isThemeDark(context)
                                                    ? ColorProvider.light
                                                    : ColorProvider.dark)
                                                    .withOpacity(
                                                    isAnimationView ? 0.24 : 0),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                  "animation view")),
                                        ),
                                        InkWell(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(32)),
                                          onTap: () =>
                                              setState(() {
                                                isAnimationView = false;
                                              }),
                                          child: Container(
                                              height: 24,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(32)),
                                                color: (ColorProvider
                                                    .isThemeDark(context)
                                                    ? ColorProvider.light
                                                    : ColorProvider.dark)
                                                    .withOpacity(
                                                    isAnimationView ? 0 : 0.24),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                  "raw data view")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedCrossFade(
                                      firstChild: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(16)),
                                          color: (ColorProvider.isThemeDark(context)
                                              ? ColorProvider.light
                                              : ColorProvider.dark)
                                              .withOpacity(0.16),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 264,
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  alignment: Alignment.center,
                                                  child: IgnorePointer(
                                                    child: ScrollConfiguration(
                                                      behavior: DisableScrollGlow(),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          itemCount: simulationController
                                                              .perceptron!.inputsNumber,
                                                          itemBuilder: (context, index) {
                                                            return Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 8,),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 96,
                                                                    padding: const EdgeInsets.all(8),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      const BorderRadius.all(Radius.circular(16)),
                                                                      color: (ColorProvider.isThemeDark(context)
                                                                          ? ColorProvider.yellowDark
                                                                          : ColorProvider.yellowLight)
                                                                          .withOpacity(0.64),
                                                                    ),
                                                                    alignment: Alignment.center,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(simulationController.perceptron!.inputs[index].name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                                        const SizedBox(height: 4,),
                                                                        Text(simulationController.perceptron!.inputs[index].value.toStringAsFixed(4), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: ShaderMask(
                                                                      blendMode: BlendMode.overlay,
                                                                      shaderCallback: (rect) => LinearGradient(
                                                                        colors: [
                                                                          getColor(simulationController.perceptron!.weights[index]),
                                                                          getColor(simulationController.perceptron!.weights[index]),
                                                                        ]
                                                                      ).createShader(rect),
                                                                      child: Container(
                                                                        height: 8,
                                                                        color: (ColorProvider.isThemeDark(context)
                                                                            ? ColorProvider.light
                                                                            : ColorProvider.dark)
                                                                            .withOpacity(0.16),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 76,
                                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      const BorderRadius.all(Radius.circular(16)),
                                                                      color: (ColorProvider.isThemeDark(context)
                                                                          ? ColorProvider.yellowDark
                                                                          : ColorProvider.yellowLight)
                                                                          .withOpacity(0.32),
                                                                    ),
                                                                    alignment: Alignment.center,
                                                                    child: Text(simulationController.perceptron!.weights[index].toStringAsFixed(4), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),),

                                                                  ),
                                                                  ShaderMask(
                                                                    blendMode: BlendMode.color,
                                                                    shaderCallback: (rect) => LinearGradient(
                                                                        stops: const [
                                                                          0.4,
                                                                          1
                                                                        ],
                                                                        colors: [
                                                                          getColor(simulationController.perceptron!.weights[index]),
                                                                          getColor(simulationController.perceptron!.weights[index]),
                                                                        ]
                                                                    ).createShader(rect),
                                                                    child: Container(
                                                                      width: 32,
                                                                      height: 8,
                                                                      color: (ColorProvider.isThemeDark(context)
                                                                          ? ColorProvider.light
                                                                          : ColorProvider.dark)
                                                                          .withOpacity(0.16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 8,
                                                  width: 32,
                                                  color: (ColorProvider.isThemeDark(context)
                                                      ? ColorProvider.light
                                                      : ColorProvider.dark)
                                                      .withOpacity(0.16),

                                                ),
                                                Container(
                                                  width: 76,
                                                  height: 76,
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (ColorProvider.isThemeDark(context)
                                                        ? ColorProvider.yellowDark
                                                        : ColorProvider.yellowLight)
                                                        .withOpacity(0.72),
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    child: Image.asset("assets/images/sum_${ColorProvider.isThemeDark(context) ? "light" : "dark"}.png"),
                                                  ),
                                                ),
                                                Container(
                                                  height: 8,
                                                  width: 32,
                                                  color: (ColorProvider.isThemeDark(context)
                                                      ? ColorProvider.light
                                                      : ColorProvider.dark)
                                                      .withOpacity(0.16),

                                                ),
                                                Container(
                                                  width: 112,
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                    color: (ColorProvider.isThemeDark(context)
                                                        ? ColorProvider.yellowDark
                                                        : ColorProvider.yellowLight)
                                                        .withOpacity(0.72),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(simulationController.perceptron!.activationFunction.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      secondChild: Text(
                                        simulationController.perceptron!
                                            .print(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),),
                                      crossFadeState: isAnimationView
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      duration: duration600)
                                ],
                              )),
                          const SizedBox(height: 4,),
                          Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                              color: (ColorProvider.isThemeDark(context)
                                  ? ColorProvider.light
                                  : ColorProvider.dark)
                                  .withOpacity(0.32),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Percentage of correctly identified\n test examples: ${simulationController
                                  .perceptron!.percentageOfCorrectAnswers
                                  .toStringAsFixed(2)}%", maxLines: 2,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,),
                          ),
                          Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                              color: (ColorProvider.isThemeDark(context)
                                  ? ColorProvider.light
                                  : ColorProvider.dark)
                                  .withOpacity(0.16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Text(
                                  "Training error",
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (simulationController.perceptron!
                                    .errorChartPointsTraining.isNotEmpty)
                                  IgnorePointer(
                                    child: Container(
                                      width: size.width,
                                      height: size.width * 0.8,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: (ColorProvider.isThemeDark(
                                            context)
                                            ? ColorProvider.dark
                                            : ColorProvider.light)
                                            .withOpacity(0.48),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(32)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, right: 32, bottom: 12),
                                          child: LineChart(
                                            LineChartData(
                                              minY: 0,
                                              maxY: 1,
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
                                                    showTitles: false,
                                                    interval: 1,
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    interval: 0.1,
                                                    showTitles: true,
                                                    reservedSize: 36,
                                                  ),
                                                ),
                                              ),
                                              gridData: FlGridData(
                                                show: false,
                                                verticalInterval: 1,
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: (ColorProvider
                                                        .isThemeDark(
                                                        context)
                                                        ? ColorProvider
                                                        .light
                                                        : ColorProvider
                                                        .dark)
                                                        .withOpacity(0.48),
                                                    strokeWidth: 1.6,
                                                  );
                                                },
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: (ColorProvider
                                                        .isThemeDark(
                                                        context)
                                                        ? ColorProvider
                                                        .light
                                                        : ColorProvider
                                                        .dark)
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
                                                  spots: simulationController
                                                      .perceptron!
                                                      .errorChartPointsTraining,
                                                  gradient: LinearGradient(
                                                      colors: ColorProvider
                                                          .isThemeDark()
                                                          ? [
                                                        ColorProvider
                                                            .blueDark,
                                                        ColorProvider
                                                            .greenDark
                                                      ]
                                                          : [
                                                        ColorProvider
                                                            .blueLight,
                                                        ColorProvider
                                                            .greenLight
                                                      ],
                                                      begin:
                                                      const FractionalOffset(
                                                          0.0, 0.0),
                                                      end:
                                                      const FractionalOffset(
                                                          0.5, 0.0),
                                                      stops: const [0.0, 1.0],
                                                      tileMode: TileMode.clamp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: size.width,
                                    height: size.width * 0.8 - 16,
                                    margin: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(32)),
                                      color: (ColorProvider.isThemeDark(context)
                                          ? ColorProvider.dark
                                          : ColorProvider.light)
                                          .withOpacity(0.48),
                                    ),
                                    child: const Text(
                                      "There is not enough data to create a chart",
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Steps: ${simulationController.perceptron!
                                          .errorChartPointsTraining.length}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Epoch: ${simulationController.perceptron!
                                          .epoch}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Error: ${simulationController.perceptron!
                                          .lastErrorTraining.toStringAsFixed(
                                          10)}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                              color: (ColorProvider.isThemeDark(context)
                                  ? ColorProvider.light
                                  : ColorProvider.dark)
                                  .withOpacity(0.16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Text(
                                  "Testing error",
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (simulationController.perceptron!
                                    .errorChartPointsTesting.isNotEmpty)
                                  IgnorePointer(
                                    child: Container(
                                      width: size.width,
                                      height: size.width * 0.8,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: (ColorProvider.isThemeDark(
                                            context)
                                            ? ColorProvider.dark
                                            : ColorProvider.light)
                                            .withOpacity(0.48),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(32)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, right: 32, bottom: 12),
                                          child: LineChart(
                                            LineChartData(
                                              minY: 0,
                                              maxY: 1,
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
                                                    showTitles: false,
                                                    interval: 1,
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    interval: 0.1,
                                                    showTitles: true,
                                                    reservedSize: 36,
                                                  ),
                                                ),
                                              ),
                                              gridData: FlGridData(
                                                show: false,
                                                verticalInterval: 1,
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: (ColorProvider
                                                        .isThemeDark(
                                                        context)
                                                        ? ColorProvider
                                                        .light
                                                        : ColorProvider
                                                        .dark)
                                                        .withOpacity(0.48),
                                                    strokeWidth: 1.6,
                                                  );
                                                },
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: (ColorProvider
                                                        .isThemeDark(
                                                        context)
                                                        ? ColorProvider
                                                        .light
                                                        : ColorProvider
                                                        .dark)
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
                                                  spots: simulationController
                                                      .perceptron!
                                                      .errorChartPointsTesting,
                                                  gradient: LinearGradient(
                                                      colors: ColorProvider
                                                          .isThemeDark()
                                                          ? [
                                                        ColorProvider
                                                            .blueDark,
                                                        ColorProvider
                                                            .greenDark
                                                      ]
                                                          : [
                                                        ColorProvider
                                                            .blueLight,
                                                        ColorProvider
                                                            .greenLight
                                                      ],
                                                      begin:
                                                      const FractionalOffset(
                                                          0.0, 0.0),
                                                      end:
                                                      const FractionalOffset(
                                                          0.5, 0.0),
                                                      stops: const [0.0, 1.0],
                                                      tileMode: TileMode.clamp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: size.width,
                                    height: size.width * 0.8 - 16,
                                    margin: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(32)),
                                      color: (ColorProvider.isThemeDark(context)
                                          ? ColorProvider.dark
                                          : ColorProvider.light)
                                          .withOpacity(0.48),
                                    ),
                                    child: const Text(
                                      "There is not enough data to create a chart",
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Steps: ${simulationController.perceptron!
                                          .errorChartPointsTesting.length}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Epoch: ${simulationController.perceptron!
                                          .epoch}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Error: ${simulationController.perceptron!
                                          .lastErrorTesting.toStringAsFixed(
                                          10)}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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


