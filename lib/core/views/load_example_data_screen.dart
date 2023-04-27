import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/perceptron_controller.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';

class LoadExampleDataScreen extends StatefulWidget {
  const LoadExampleDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadExampleDataScreen> createState() => _LoadExampleDataScreenState();
}

class _LoadExampleDataScreenState extends State<LoadExampleDataScreen> {
  final PerceptronController perceptronController = Get.find();

  @override
  void initState() {
    super.initState();
    perceptronController.loadExampleData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      return WillPopScope(
        onWillPop:  () async => false,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(min(size.width, size.height) * 0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    perceptronController.isDataLoaded
                        ? TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: duration1200,
                            builder: (context, value, widget) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
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
                                  Icon(
                                    Icons.file_copy,
                                    size: size.width * 0.16,
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
                                  value: perceptronController.isDataLoading
                                      ? null
                                      : 0,
                                ),
                              ),
                              Icon(
                                Icons.file_copy,
                                size: size.width * 0.16,
                              )
                            ],
                          ),
                    const SizedBox(
                      height: 64,
                    ),
                    Opacity(
                      opacity: 0.9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        height: 48,
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: AnimatedCrossFade(
                          firstChild: const Text(
                            "Data has been loaded!!!",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          secondChild: const Text(
                            "Please wait, data is currently being read and copied",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          crossFadeState: perceptronController.isDataLoaded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: duration600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      onTap: () {
                        perceptronController.loadExampleDataCancel();
                        Get.back(closeOverlays: true);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            width: perceptronController.isDataLoaded
                                ? (size.width - min(size.width, size.height) * 0.2) - 48 - 12
                                : (size.width - min(size.width, size.height) * 0.2),
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
                          AnimatedContainer(
                              width: perceptronController.isDataLoaded
                                  ? 8
                                  : 0,
                              duration: duration400),
                          AnimatedContainer(
                              width: perceptronController.isDataLoaded
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
                              child: Icon(Icons.check, color: ColorProvider.isThemeDark(context)
                                  ? ColorProvider.dark
                                  : ColorProvider.light,)),
                        ],
                      ),
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
