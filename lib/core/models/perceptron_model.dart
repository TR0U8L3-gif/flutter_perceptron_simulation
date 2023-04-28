import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/core/models/node_model.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';

class Perceptron {
  int inputsNumber;
  Output? output;
  List<Input> inputs = [];
  late List<double> weights;
  late List<double> errors;
  ActivationFunction activationFunction;
  double learningRate;
  late double _bias;

  get bias => _bias;

  Perceptron(
      {required this.inputsNumber,
      required this.learningRate,
      required this.activationFunction,
      this.output});

  void initialize({List<String> inputNames = const [], String? outputName}) {
    if (inputNames.isEmpty || (inputsNumber != inputNames.length || outputName == null)) {
      for (int i = 0; i < inputsNumber; i++) {
        inputs.add(Input(name: "input ${i + 1}", value: 0));
      }

      output = Output(name: "output", value: 0);
    } else {
      for (String name in inputNames) {
        inputs.add(Input(name: name, value: 0));
      }
      output = Output(name: outputName, value: 0);
    }
  }

  void generateRandomWeights() {
    if (inputs.isEmpty || output == null) return;
    for (int i = 0; i < inputsNumber; i++) {
      double randomNumber = inRange(-1, 1).toDouble();
      weights[i] = randomNumber;
    }
  }

  void updateWeights({required double error}) {
    if (inputs.isEmpty || output == null) return;
    _bias += learningRate * error;
    for (int i = 0; i < inputsNumber; i++) {
      weights[i] += learningRate * error * inputs[i].value;
    }
  }

  String weightsToString() {
    String ss = "{";
    for (int i = 0; i < inputsNumber; i++) {
      ss += "${weights[i]}";
      if (i < inputsNumber - 1) {
        ss += ",";
      }
    }
    ss += "}";
    return ss;
  }

  void train(
      {required List<List<double>> trainingInputData,
      required List<double> trainingOutputData,
      required int maxEpochs}) {
    if (inputs.isEmpty || output == null) return;

    List<double> perceptronInputs = [];
    double perceptronOutput = 0;

    generateRandomWeights();
    debugPrint("Initial weights: ${weightsToString()}");

    int epoch = 0;
    double globalError;
    do {
      globalError = 0;
      for (int i = 0; i < trainingInputData.length; i++) {
        perceptronInputs = trainingInputData[i];
        double output = trainingOutputData[i];
        //TODO output and input to object

        //calculating weight sum
        double weightSum = 0;
        for (int weightNumber = 0;
            weightNumber < inputsNumber;
            weightNumber++) {
          weightSum += perceptronInputs[weightNumber] * weights[weightNumber];
        }

        //calculate predicted output
        perceptronOutput = activationFunction.calculate(weightSum + _bias);

        //calculate error
        double error = output - perceptronOutput;
        globalError += error * error;

        //update weights if outputs are different
        if (output != perceptronOutput) updateWeights(error: error);
      }
      epoch++;

      debugPrint(
          "Epoch $epoch, weights ${weightsToString()}, global error: $globalError ");
      errors.add(globalError);
    } while (globalError > 0.001 &&
        epoch < maxEpochs); // Stopping criteria can be adjusted
  }

  double predict(List<double> input) {
    double weightSum = 0;
    for (int weightNumber = 0; weightNumber < input.length; weightNumber++) {
      weightSum += input[weightNumber] * weights[weightNumber];
    }
    return activationFunction.calculate(weightSum + _bias);
  }
}
