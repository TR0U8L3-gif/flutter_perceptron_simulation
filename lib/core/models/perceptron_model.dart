import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:perceptron_simulation/core/controllers/perceptron/simulation_controller.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/core/models/node_model.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';
import 'package:collection/collection.dart';

class Perceptron{

  int inputsNumber;

  Output? output;
  List<Input> inputs = [];
  ActivationFunction activationFunction;
  double learningRate;
  List<double> weights = [];
  double bias = 0.0;

  //data
  Map<double, String> stringOutputs = {};
  List<double> trainingOutputData = [];
  List<List<double>> trainingInputData = [];
  List<double> testingOutputData = [];
  List<List<double>> testingInputData = [];

  //simulation
  List<FlSpot> errorChartPointsTraining = [];
  List<FlSpot> errorChartPointsTesting = [];
  double percentageOfCorrectAnswers = 0;
  int epoch = 0;
  bool isInitialized = false;

  double get lastErrorTraining => errorChartPointsTraining.isNotEmpty ? errorChartPointsTraining[errorChartPointsTraining.length-1].y : 0;
  double get lastErrorTesting => errorChartPointsTesting.isNotEmpty ? errorChartPointsTesting[errorChartPointsTesting.length-1].y : 0;
  //init
  Perceptron(
      {required this.inputsNumber,
        required this.learningRate,
        required this.activationFunction,
        this.output});

  void initialize({ List<String> inputNames = const [], String? outputName}) {
    if (inputNames.isEmpty || (inputsNumber != inputNames.length || outputName == null)) {
      for (int i = 0; i < inputsNumber; i++) {
        inputs.add(Input(name: "input ${i + 1}", value: 0));
      }

      output = Output(name: "output", value: 0);
    }
    else {
      for (String name in inputNames) {
        inputs.add(Input(name: name.trimLeft().trimRight(), value: 0));
      }
      output = Output(name: outputName, value: 0);
    }
    resetData();
  }

  //data
  void setData({required List<List<double>> testingInputData, required List<double> testingOutputData, required List<List<double>> trainingInputData, required List<double> trainingOutputData, required Map<double, String> stringOutputs}){
    this.trainingInputData = trainingInputData;
    this.trainingOutputData = trainingOutputData;
    this.testingInputData = testingInputData;
    this.testingOutputData = testingOutputData;
    this.stringOutputs = stringOutputs;
  }

  List<String> trainingOutputDataString() {
    List<String> result = [];
    for(double val in trainingOutputData){
      String? str = stringOutputs[val];
      if(str == null) continue;
      result.add(str);
    }
    return result;
  }

  List<String> testingOutputDataString() {
    List<String> result = [];
    for(double val in testingOutputData){
      String? str = stringOutputs[val];
      if(str == null) continue;
      result.add(str);
    }
    return result;
  }

  //calculating
  void calculateOutputValue() {
    double min = (activationFunction.min ?? -1).toDouble();
    double max = (activationFunction.max ?? 1).toDouble();

    Map<double, String> newStringOutputs = {
      min : stringOutputs.values.toList()[0],
      max : stringOutputs.values.toList()[1],
    };
    debugPrint("old map $stringOutputs\nnew map $newStringOutputs");

    //if maps are different then change values
    if(const MapEquality().equals(newStringOutputs, stringOutputs)){
      debugPrint("Outputs are equal");
      return;
    }

    double oldMin = stringOutputs.keys.toList()[0];

    List<double> newTrainingOutputData = [];
    List<double> newTestingOutputData = [];

    for(int i = 0; i < trainingOutputData.length; i++){
      if(trainingOutputData[i] == oldMin){
        newTrainingOutputData.add(min);
      }
      else{
        newTrainingOutputData.add(max);
      }
    }

    for(int i = 0; i < testingOutputData.length; i++){
      if(testingOutputData[i] == oldMin){
        newTestingOutputData.add(min);
      }
      else{
        newTestingOutputData.add(max);
      }
    }

    debugPrint("old: $trainingOutputData, new: $newTrainingOutputData");
    debugPrint("old: $testingOutputData, new: $newTestingOutputData");

    testingOutputData = newTestingOutputData;
    trainingOutputData = newTrainingOutputData;
    stringOutputs = newStringOutputs;
  }

  void generateRandomWeights() {
    weights = [];
    if (inputs.isEmpty || output == null) return;
    for (int i = 0; i < inputsNumber; i++) {
      double randomNumber = roundDouble(inRange(-1, 1).toDouble(),2);
      weights.add(randomNumber);
    }
    debugPrint("Initial weights: ${weightsToString()}");
  }

  void updateWeightsAndBias({required double error, required List<double> inputs}) {
    bias += learningRate * error;
    for (int i = 0; i < inputsNumber; i++) {
      weights[i] += learningRate * error * inputs[i];
    }
  }

  Future<void> train({required Duration delay}) async {
    List<double> correctInputs = [];
    double correctOutput = 0;

    double predictedOutput = 0;
    double error = 1;

    for(int i = 0; i < trainingInputData.length; i++){
      correctInputs = trainingInputData[i];
      correctOutput = trainingOutputData[i];

      double weightSum = 0;
      for(int index = 0; index < inputsNumber; index++){
        weightSum += correctInputs[index] * weights[index];
      }

      predictedOutput = activationFunction.calculate(weightSum + bias);

      error = correctOutput - predictedOutput;
      updateWeightsAndBias(error: error, inputs: correctInputs);
      addChartErrorPointTraining(error * error);
      test();

      //update view
      output!.value = predictedOutput;
      output!.correctValue = correctOutput;
      for(int index = 0; index < inputsNumber; index++){
        inputs[index].value = correctInputs[index];
      }

      Get.find<SimulationController>().updateSimulation();
      await Future.delayed(Duration(milliseconds: Get.find<SimulationController>().simulationSpeed == 0 ? 0 : delay.inMilliseconds ~/  Get.find<SimulationController>().simulationSpeed * 2));
    }
    epoch++;
  }

  void trainEpoch() {
    List<double> correctInputs = [];
    double correctOutput = 0;

    double predictedOutput = 0;
    double error = 1;

    for(int i = 0; i < trainingInputData.length; i++){
      correctInputs = trainingInputData[i];
      correctOutput = trainingOutputData[i];

      double weightSum = 0;
      for(int index = 0; index < inputsNumber; index++){
        weightSum += correctInputs[index] * weights[index];
      }

      predictedOutput = activationFunction.calculate(weightSum + bias);

      error = correctOutput - predictedOutput;
      updateWeightsAndBias(error: error, inputs: correctInputs);
      addChartErrorPointTraining(error * error);
      test();
    }

    //visual update
    epoch++;
    output!.value = predictedOutput;
    output!.correctValue = correctOutput;
    for(int index = 0; index < inputsNumber; index++){
      inputs[index].value = correctInputs[index];
    }
  }

  double predict(List<double> input) {
    double weightSum = 0;
    for (int index = 0; index < input.length; index++) {
      weightSum += input[index] * weights[index];
    }
    return activationFunction.calculate(weightSum + bias);
  }

  void test(){
    int testingLength = testingInputData.length;
    double error = 1;
    double correct = 0;
    for(int i = 0; i < testingLength; i++) {
      double correctOutput = testingOutputData[i];
      List<double> correctInputs = testingInputData[i];

      double predictedOutput = predict(correctInputs);
      error = correctOutput - predictedOutput;
      if(predictedOutput.round() == correctOutput){
        correct++;
      }
    }

    addChartErrorPointTesting(error * error);
    percentageOfCorrectAnswers = (correct/testingLength) * 100;
  }

  //visualization
  void addChartErrorPointTraining(double globalError) {
    int length = errorChartPointsTraining.length;
    errorChartPointsTraining.add(FlSpot(length + 1, globalError));
  }

  void addChartErrorPointTesting(double globalError) {
    int length = errorChartPointsTesting.length;
    errorChartPointsTesting.add(FlSpot(length + 1, globalError));
  }

  void resetData(){
    weights = [];
    bias = 0.0;
    epoch = 0;
    errorChartPointsTraining = [];
    errorChartPointsTesting= [];
    percentageOfCorrectAnswers = 0;
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
    result += "Steps: ${errorChartPointsTraining.length}\n";
    result += "Epoch: $epoch\n";
    result += "Global error: ${errorChartPointsTraining.isEmpty ? "null" : errorChartPointsTraining[errorChartPointsTraining.length-1]}\n";
    result += "Testing error: ${errorChartPointsTesting.isEmpty ? "null" : errorChartPointsTesting[errorChartPointsTesting.length-1]}\n";
    result += "Percentage: $percentageOfCorrectAnswers\n";
    result += "trainingInput: ${trainingInputData.length}\n";
    result += "trainingOutput: ${trainingOutputData.length}\n";
    result += "testingInput: ${testingInputData.length}\n";
    result += "testingOutput: ${testingOutputData.length}\n";
    return result;
  }

  String print() {
    String result = "Perceptron\n";
    for(Input input in inputs){
      result += "Input[${input.name}]: ${input.value.toStringAsFixed(2)}\n";
    }
    for(int i = 0; i < weights.length; i++){
      result += "Weight[${i+1}]: ${weights[i].toStringAsFixed(8)}\n";
    }
    result += "Activation function: ${activationFunction.name}\n";
    if(output != null){
      result += "Output[${output!.name}]: ${output!.value.toStringAsFixed(8)}";
    }
    return result;
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
}
