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

  //TODO: one epoch train function that works
  void train(){
    for(Input inp in inputs){
      inp.value ++;
    }
  }

  double predict(List<double> input) {
    double weightSum = 0;
    for (int weightNumber = 0; weightNumber < input.length; weightNumber++) {
      weightSum += input[weightNumber] * weights[weightNumber];
    }
    return activationFunction.calculate(weightSum + _bias);
  }

  void resetData(){

    weights = [];
    _bias = 0.0;

    errorCharPoints = [];
    isLearning = true;
    isTesting = true;

    for(Input input in inputs){
      input.value = 0;
    }

    if(output != null){
      output!.value = 0;
    }

    generateRandomWeights();
  }

  @override
  String toString() {
    String result = "Perceptron\n";
    for(Input input in inputs){
      result += "Input[${input.name}]: ${input.value}\n";
    }
    for(int i = 0; i < weights.length; i++){
      result += "Weight[${i+1}]: ${weights[i]}\n";
    }
    if(output != null){
      result += "Output[${output!.name}]: ${output!.value}\n";
    }
    result += "Epoch: ${errorCharPoints.length}\n";
    result += "isLearning: $isLearning\n";
    result += "isTesting: $isTesting\n\n";
    result += "trainingInput: ${trainingInputData.length}\n";
    result += "trainingOutput: ${trainingOutputData.length}\n";
    result += "testingInput: ${testingInputData.length}\n";
    result += "testingOutput: ${testingOutputData.length}\n";
    return result;
  }
}
