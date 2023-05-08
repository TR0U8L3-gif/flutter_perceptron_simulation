import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/core/models/node_model.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';

class Perceptron {

  int inputsNumber;

  Output? output;
  List<Input> inputs = [];
  ActivationFunction activationFunction;
  double learningRate;

  List<double> weights = [];
  double _bias = 0.0;

  //data
  List<double> trainingOutputData = [];
  List<List<double>> trainingInputData = [];
  List<double> testingOutputData = [];
  List<List<double>> testingInputData = [];
  //simulation
  double milliSeconds = 10;
  double simulationSpeed = 1;
  List<FlSpot> errorCharPoints = [];
  bool isInitialized = false;
  bool isLearning = true;
  bool isTesting = true;

  get bias => _bias;

  Perceptron(
      {required this.inputsNumber,
      required this.learningRate,
      required this.activationFunction,
      this.output});

  //init
  void initialize({ List<String> inputNames = const [], String? outputName}) {
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
    resetData();
  }

  void setData({required List<List<double>> testingInputData, required List<double> testingOutputData, required List<List<double>> trainingInputData, required List<double> trainingOutputData}){
    this.trainingInputData = trainingInputData;
    this.trainingOutputData = trainingOutputData;
    this.testingInputData = testingInputData;
    this.testingOutputData = testingOutputData;
  }

  //calculating
  void addChartErrorPoint(double globalError) {
    int length = errorCharPoints.length;
    errorCharPoints.add(FlSpot(length + 1, globalError));
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

  void generateRandomWeights() {
    weights = [];
    if (inputs.isEmpty || output == null) return;
    for (int i = 0; i < inputsNumber; i++) {
      double randomNumber = inRange(-1, 1).toDouble();
      weights.add(randomNumber);
    }
    debugPrint("Initial weights: ${weightsToString()}");
  }

  void updateWeights({required double error}) {
    if (inputs.isEmpty || output == null) return;
    _bias += learningRate * error;
    for (int i = 0; i < inputsNumber; i++) {
      weights[i] += learningRate * error * inputs[i].value;
    }
  }


  void trainEpoch ({required int epochs}) async {
    if (weights.isEmpty || inputs.isEmpty || output == null) return;

    List<double> perceptronInputs = [];
    double perceptronOutput = 0;
    double correctOutput = 0;

    int epoch = errorCharPoints.length;
    double globalError;

    do {
      globalError = 0;
      for (int i = 0; i < trainingInputData.length; i++) {

        //reading data
        perceptronInputs = trainingInputData[i];
        correctOutput = trainingOutputData[i];

        //calculating weight sum
        double weightSum = 0;
        for (int weightNumber = 0; weightNumber < inputsNumber; weightNumber++) {
          weightSum += perceptronInputs[weightNumber] * weights[weightNumber];
        }

        //calculate predicted output
        perceptronOutput = activationFunction.calculate(weightSum + _bias);

        //calculate error
        double error = correctOutput - perceptronOutput;
        globalError += error * error;
        addChartErrorPoint(globalError);

        //update weights if outputs are different
        if (correctOutput != perceptronOutput) updateWeights(error: error);

        //update inputs and output
        output!.value = perceptronOutput;
        for(int index = 0; index < inputsNumber; index++){
          inputs[index].value = perceptronInputs[index];
        }

        //delay
        if(simulationSpeed > 0){
          await Future.delayed(Duration(milliseconds: milliSeconds~/simulationSpeed));
        }
      }
      epoch++;

      debugPrint("Epoch $epoch, weights ${weightsToString()}, global error: $globalError");
    } while (globalError > 0.001 && epoch < epochs);// Stopping criteria can be adjusted

    if(globalError > 0.001 && epoch < epochs){
      isLearning = false;
    }
  }

  double predict(List<double> input) {
    double weightSum = 0;
    for (int weightNumber = 0; weightNumber < input.length; weightNumber++) {
      weightSum += input[weightNumber] * weights[weightNumber];
    }
    return activationFunction.calculate(weightSum + _bias);
  }

  //simulation
  void resetData(){

    weights = [];
    _bias = 0.0;

    simulationSpeed = 1;
    errorCharPoints = [];
    isLearning = true;
    isTesting = true;

    generateRandomWeights();
  }
}
