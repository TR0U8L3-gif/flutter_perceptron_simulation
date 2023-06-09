import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';

class LoadDataScreen extends StatelessWidget {
  LoadDataScreen({Key? key}) : super(key: key);

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
              child: Container(
                padding: EdgeInsets.all(min(size.width, size.height) * 0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    simulationController.isDataLoaded
                        ? TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: duration1200,
                            builder: (context, value, widget) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  IgnorePointer(
                                    child: SizedBox(
                                      width: size.width * 0.56,
                                      height: size.width * 0.56,
                                      child: CircularProgressIndicator(
                                        color: ColorProvider.isThemeDark(context)
                                            ? ColorProvider.yellowDark
                                            : ColorProvider.yellowLight,
                                        strokeWidth: 8,
                                        value: value,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.file_copy,
                                    size: size.width * 0.16,
                                    color: simulationController.isFastLoading
                                        ? ColorProvider.isThemeDark(context)
                                          ? ColorProvider.yellowDark
                                          : ColorProvider.yellowLight
                                        : ColorProvider.isThemeDark(context)
                                          ? ColorProvider.light
                                          : ColorProvider.dark,
                                  )
                                ],
                              );
                            })
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.56,
                                height: size.width * 0.56,
                                child: CircularProgressIndicator(
                                  color: ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark,
                                  strokeWidth: 8,
                                  value: simulationController.isDataLoading
                                      ? null
                                      : 0,
                                ),
                              ),
                              InkWell(
                                onTap: () => simulationController.turnOnFastLoading(),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                child: Icon(
                                  Icons.file_copy,
                                  size: size.width * 0.16,
                                  color: simulationController.isFastLoading
                                      ? ColorProvider.isThemeDark(context)
                                      ? ColorProvider.yellowDark
                                      : ColorProvider.yellowLight
                                      : ColorProvider.isThemeDark(context)
                                      ? ColorProvider.light
                                      : ColorProvider.dark,
                                ),
                              )
                            ],
                          ),
                    simulationController.isDataLoading
                        ? Container(
                            height: 64,
                            width: size.width,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.topCenter,
                            child: Text(simulationController.loadingDataLine, overflow: TextOverflow.ellipsis,),
                          )
                        : const SizedBox(
                            height: 64,
                          ),
                    Opacity(
                      opacity: 0.9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        height: 48,
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: AnimatedCrossFade(
                          firstChild: const Text(
                            "Data has been loaded!!!",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          secondChild: const Text(
                            "Please wait, data is currently being read and copied",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          crossFadeState: simulationController.isDataLoaded
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
                          borderRadius: const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            simulationController.cancel();
                            Get.offAllNamed(routeController.getMainRoute);
                          },
                          child: AnimatedContainer(
                            width: simulationController.isDataLoaded
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
                            width: simulationController.isDataLoaded ? 8 : 0,
                            duration: duration400),
                        InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(32)),
                          onTap: () {
                            Get.toNamed(routeController.getDataSplittingRoute);
                          },
                          child: AnimatedContainer(
                              width: simulationController.isDataLoaded ? 48 : 0,
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
          ),
          appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
        ),
      );
    });
  }
}
