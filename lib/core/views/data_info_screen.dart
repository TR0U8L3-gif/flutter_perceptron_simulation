import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';

class DataInfoScreen extends StatelessWidget {
  DataInfoScreen({Key? key}) : super(key: key);

  final ScrollController firstScrollController = ScrollController();
  final ScrollController secondScrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = min(size.width, size.height) * 0.1;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    child: const Text(
                      "Example file with data for perceptron learning process",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              Opacity(
                opacity: 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: const Text(
                    "The first line of the file may or may not contain the names of inputs and output listed after a comma. Example with data names for 4 inputs and output: ",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,

                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: (ColorProvider.isThemeDark() ? ColorProvider.light : ColorProvider.dark).withOpacity(0.96),
                ),
                child: Scrollbar(
                  controller: firstScrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: ScrollConfiguration(
                    behavior: DisableScrollGlow(),
                    child: SingleChildScrollView(
                      controller: firstScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Text(
                          "sepal length, sepal width, petal length, petal width, type",
                          style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              Opacity(
                opacity: 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: const Text(
                    "Complete remaining rows with the appropriate amount of inputs and outputs. Inputs must be numbers, but outputs can be both numbers or strings. Example for 4 inputs and string output: ",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,

                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 128,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: (ColorProvider.isThemeDark() ? ColorProvider.light : ColorProvider.dark).withOpacity(0.96),
                ),
                child: Scrollbar(
                  controller: secondScrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: ScrollConfiguration(
                    behavior: DisableScrollGlow(),
                    child: SingleChildScrollView(
                      controller: secondScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "5.1, 3.5, 1.4, 0.2, Iris-setosa",
                            style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text(
                            "5.4, 3.4, 1.5, 0.4, Iris-setosa",
                            style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text(
                            "4.9, 3.1, 1.5, 0.1, Iris-setosa",
                            style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text(
                            "5.6, 3.0, 4.5, 1.5, Iris-versicolor",
                            style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text(
                            "6.2, 2.2, 4.5, 1.5, Iris-versicolor",
                            style: TextStyle(fontSize: 18, color: ColorProvider.isThemeDark() ? ColorProvider.dark : ColorProvider.light,),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  onTap: () => Get.back(closeOverlays: true),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      color: ColorProvider.isThemeDark(context)
                          ? ColorProvider.light
                          : ColorProvider.dark,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Go Back",
                      style: TextStyle(
                        color: ColorProvider.isThemeDark(context) ? ColorProvider.yellowDark : ColorProvider.yellowLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
    );
  }
}
