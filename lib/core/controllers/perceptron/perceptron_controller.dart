import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/core/models/perceptron_model.dart';

class PerceptronController extends GetxController {
  final Rx<Perceptron?> _perceptron = Rx(null);
  final Rx<bool> _isDataLoading = Rx(false);
  final Rx<bool> _isDataLoaded = Rx(false);
  final Rx<String> _loadingDataLine = Rx("...");
  final _dataLoadingController = StreamController<String>.broadcast();

  List<List<double>> allInputData = [];
  List<String> allOutputData = [];

  List<List<double>> trainingInputData = [];
  List<String> trainingOutputData = [];

  List<List<double>> predictInputData = [];
  List<String> predictOutputData = [];

  get perceptron => _perceptron.value;
  get isDataLoading => _isDataLoading.value;
  get isDataLoaded => _isDataLoaded.value;
  get loadingDataLine => _loadingDataLine.value;

  void loadExampleData() async {
    //clear data before start
    loadDataCancel();

    //start loading
    String signal = "pending";
    _dataLoadingController.add("pending");
    _isDataLoading.value = true;
    List<String> dataFile = [];

    //reading data from file and splitting it by new lines
    String response = await rootBundle.loadString('assets/data/data.txt');
    LineSplitter.split(response).forEach((line) => dataFile.add(line));

    //signal listener
    StreamSubscription listener = _dataLoadingController.stream.listen((event) {
      debugPrint("New signal received: $event");
      signal = event;
    });

    //executing data
    int i = 0;
    List<String> outputData = [];
    List<List<double>> inputData = [];

    await Future.forEach(dataFile, (line) async {
      if (signal == "abort") {
        return;
      }

      //informing user which line is processing
      _loadingDataLine.value = "$i: $line";

      List<String> data = line.split(',');

      //first line is inputs and output names
      if (i == 0) {
        int inputsNumber = data.length - 1;
        String outputName = data[data.length - 1];
        List<String> inputNames = data.getRange(0, data.length - 1).toList();
        debugPrint(
            "$inputsNumber inputNames: $inputNames, outputName: $outputName");
        _perceptron.value = Perceptron(
            inputsNumber: inputsNumber,
            learningRate: 0.1,
            activationFunction: SigmoidFunction())
          ..initialize(inputNames: inputNames, outputName: outputName);
      }

      //other lines are perceptron learning data
      else {
        String output = data[data.length - 1];
        List<String> input = data.getRange(0, data.length - 1).toList();
        outputData.add(output);
        inputData.add(input.map((source) => double.parse(source)).toList());
      }

      //increment line number
      i++;

      //delay for visual effect
      await Future.delayed(duration50);
    });
    // cancel listener
    listener.cancel();

    // return if aborted loading data
    if (signal == "abort") {
      loadDataCancel();
      return;
    }

    //everything goes well :)
    _isDataLoaded.value = true;
    _isDataLoading.value = false;
    _dataLoadingController.add("done");
    allOutputData = outputData;
    allInputData = inputData;

    debugPrint("input [${allInputData.length}]: $allInputData\noutput [${allOutputData.length}]: $allOutputData");
  }

  void loadDataCancel() async {
    if (_isDataLoading.value) {
      debugPrint("abort loading example file");
      _dataLoadingController.add("abort");
    }
    _perceptron.value = null;
    _loadingDataLine.value = "...";
    _isDataLoading.value = false;
    _isDataLoaded.value = false;
    allOutputData = [];
    allInputData = [];
  }
}
