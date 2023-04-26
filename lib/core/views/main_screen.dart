import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';
import 'package:perceptron_simulation/tools/widgets/app_bar_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(min(size.width, size.height) * 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    "assets/images/perceptron_${ColorProvider.isThemeDark(context) ? "light" : "dark"}.png"),
                const SizedBox(
                  height: 64,
                ),
                 Opacity(
                  opacity: 0.9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    child: const Text(
                        "To simulate the perceptron learning process, you need to choose one of the options: ",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,

                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
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
                    "load data from file",
                    style: TextStyle(
                      color: ColorProvider.isThemeDark(context) ? ColorProvider.yellowDark : ColorProvider.yellowLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
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
                    "load example data set",
                    style: TextStyle(
                      color: ColorProvider.isThemeDark(context) ? ColorProvider.yellowDark : ColorProvider.yellowLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: ColorProvider.isThemeDark(context) ? ColorProvider.light : ColorProvider.dark),
                        children: const [
                          TextSpan( text: "What should the perceptron learning data file look like? "),
                          TextSpan( text: "Click here to find out!", style:  TextStyle( fontWeight: FontWeight.bold, color: ColorProvider.yellowDark),),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: const GradientAppBar(title: "Perceptron Learning Simulation"),
    );
  }
}
