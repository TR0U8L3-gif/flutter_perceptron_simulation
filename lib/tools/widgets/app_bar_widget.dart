import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/theme_provider.dart';

class GradientAppBar extends StatelessWidget with PreferredSizeWidget{
  final String title;
  final double barHeight = 50.0;
  const GradientAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return PreferredSize(
      preferredSize: Size(
          MediaQuery.of(context).size.width,
          150.0
      ),
      child: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        height: statusBarHeight + barHeight,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
              colors: ColorProvider.isThemeDark() ?  [ColorProvider.blueDark, ColorProvider.greenDark] : [ColorProvider.blueLight, ColorProvider.greenLight],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}