import 'dart:math';

abstract class ActivationFunction{
  late String name;
  late double? min;
  late double? max;
  late double? results;
  double calculate(double x);
}

class StepFunction implements ActivationFunction{
  @override
  String name = "step function";

  @override
  double calculate(double x){
    return x >= 0 ? 1.0 : 0.0;
  }

  @override
  double? max = 1;

  @override
  double? min = 0;

  @override
  double? results = 2;
}

class BipolarStepFunction implements ActivationFunction{
  @override
  String name = "bipolar step function";

  @override
  double calculate(double x){
    return x < 0 ? -1.0 : 1.0;
  }

  @override
  double? max = 1;

  @override
  double? min = -1;

  @override
  double? results = 2;
}

class SigmoidFunction implements ActivationFunction{
  @override
  String name = "sigmoid function";

  @override
  double calculate(double x){
    return 1.0 / (1.0 + exp(-x));
  }

  @override
  double? max = 1;

  @override
  double? min = 0;

  @override
  double? results;
}

class ReluFunction implements ActivationFunction{
  @override
  String name = "relu function";

  @override
  double calculate(double x){
    return x >= 0 ? x : 0.0;
  }

  @override
  double? max;

  @override
  double? min = 0;

  @override
  double? results;
}

class TanhFunction implements ActivationFunction{
  @override
  String name = "tanh function";

  @override
  double calculate(double x){
    if (x > 19.1) {
      return 1.0;
    }

    if (x < -19.1) {
      return -1.0;
    }

    var e1 = exp(x);
    var e2 = exp(-x);
    return (e1 - e2) / (e1 + e2);
  }

  @override
  double? max = 1;

  @override
  double? min = -1;

  @override
  double? results;
}

class SoftMaxFunction implements ActivationFunction{
  @override
  String name = "soft max function";

  @override
  double calculate(double x){
    return exp(x);
  }

  @override
  double? max;

  @override
  double? min = 0;

  @override
  double? results;
}