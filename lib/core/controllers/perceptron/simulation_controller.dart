import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:perceptron_simulation/core/models/activation_function_model.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';
import 'package:perceptron_simulation/core/models/perceptron_model.dart';

class SimulationController extends GetxController {

  //init
  final Rx<Perceptron?> _perceptron = Rx(null);
  final _dataLoadingController = StreamController<String>.broadcast();
  final Rx<bool> _isDataLoading = Rx(false);
  final Rx<bool> _isDataLoaded = Rx(false);
  final Rx<String> _loadingDataLine = Rx("...");

  //loading data
  final Rx<bool> _isFastLoading = Rx(false);

  //data sets
  List<List<double>> allInputData = [];
  List<String> allOutputData = [];
  Map<String, double> outputMap = {};
  final Rx<List<List<double>>> _trainingInputData = Rx([]);
  final Rx<List<String>> _trainingOutputData = Rx([]);
  final Rx<List<List<double>>> _predictInputData = Rx([]);
  final Rx<List<String>> _predictOutputData = Rx([]);


  //simulation
  double simulationSpeed = 1;
  final Rx<bool> _isSimulationPlaying = Rx(false);
  final Rx<bool> _isSimulationAdding = Rx(false);

  //init
  Perceptron? get perceptron => _perceptron.value;

  bool get isDataLoading => _isDataLoading.value;

  bool get isDataLoaded => _isDataLoaded.value;

  String get loadingDataLine => _loadingDataLine.value;

  //loading data
  bool get isFastLoading => _isFastLoading.value;

  //data sets
  List<List<double>> get trainingInputData => _trainingInputData.value;

  List<String> get trainingOutputData => _trainingOutputData.value;

  List<List<double>> get predictInputData => _predictInputData.value;

  List<String> get predictOutputData => _predictOutputData.value;

  //simulation
  bool get isSimulationPlaying => _isSimulationPlaying.value;
  bool get isSimulationAdding => _isSimulationAdding.value;

  //loading data
  void cancel() async {
    _isFastLoading.value = false;
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
    outputMap = {};
    _trainingInputData.value = [];
    _trainingOutputData.value = [];
    _predictInputData.value = [];
    _predictOutputData.value = [];
  }

  void turnOnFastLoading() {
    _isFastLoading.value = true;
  }

  void loadExampleData() async {
    try {
      //clear data before start
      cancel();

      //go to loading route
      Get.toNamed(routeController.getLoadDataRoute);

      //start loading
      String signal = "pending";
      _dataLoadingController.add("pending");
      _isDataLoading.value = true;
      List<String> dataFile = [];

      //reading data from file and splitting it by new lines
      String response = await rootBundle.loadString('assets/data/data.txt');
      LineSplitter.split(response).forEach((line) => dataFile.add(line));

      //signal listener
      StreamSubscription listener =
      _dataLoadingController.stream.listen((event) {
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
        await Future.delayed(_isFastLoading.value ? Duration.zero : duration15);
      });
      // cancel listener
      listener.cancel();

      // return if aborted loading data
      if (signal == "abort") {
        cancel();
        return;
      }

      //everything goes well :)
      _isDataLoaded.value = true;
      _isDataLoading.value = false;
      _dataLoadingController.add("done");
      allOutputData = outputData;
      allInputData = inputData;

      debugPrint(
          "input [${allInputData
              .length}]: $allInputData\noutput [${allOutputData
              .length}]: $allOutputData");
    } catch (e) {
      cancel();
      Get.offAllNamed(routeController.getMainRoute);
      Get.snackbar("Something went wrong", "error: $e",
          duration: const Duration(seconds: 6));
      return;
    }
  }

  void pickFileData() async {
    //picking file from device
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    //reading file data
    final file = result.files.first;
    if (file.path == null) {
      cancel();
      Get.snackbar("Wrong file path", "file ${file.name} path do not exist",
          duration: const Duration(seconds: 6));
      return;
    }

    //clear data before start
    cancel();

    //start loading
    String signal = "pending";
    _dataLoadingController.add("pending");
    _isDataLoading.value = true;
    List<String> dataFile = [];

    //reading data from file and splitting it by new lines and ignoring empty one
    File textFile = File(file.path!);
    String response = await textFile.readAsString();
    LineSplitter.split(response).forEach((line) =>
    {
      if (line.isNotEmpty) {dataFile.add(line)}
    });

    //checking if file contain data
    if (dataFile.isEmpty) {
      cancel();
      Get.snackbar("Wrong file size", "file ${file.name} is empty",
          duration: const Duration(seconds: 6));
      return;
    }
    debugPrint("$dataFile");

    //checking if first line contain names
    bool isContainingNames = true;
    String namesLine = dataFile[0];
    List<String> namesData = namesLine.split(',');
    for (String name in namesData) {
      double? result;
      try {
        result = double.tryParse(name);
      } catch (e) {
        result = null;
      }
      if (result != null) {
        isContainingNames = false;
        break;
      }
    }
    int inputsNumber = namesData.length - 1;
    String outputName = "Output";
    List<String> inputNames = [];
    for (int i = 0; i < inputsNumber; i++) {
      inputNames.add("Input[${i + 1}]");
    }
    debugPrint(
        "$inputsNumber inputNames: $inputNames, outputName: $outputName");
    _perceptron.value = Perceptron(
        inputsNumber: inputsNumber,
        learningRate: 0.1,
        activationFunction: SigmoidFunction())
      ..initialize(inputNames: inputNames, outputName: outputName);


    //go to loading route
    Get.toNamed(routeController.getLoadDataRoute);

    try {
      //signal listener
      StreamSubscription listener =
      _dataLoadingController.stream.listen((event) {
        debugPrint("New signal received: $event");
        signal = event;
      });

      //executing data
      int i = isContainingNames ? 0 : 1;
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
          //check if perceptron exist
          if (_perceptron.value == null) {
            cancel();
            Get.offAllNamed(routeController.getMainRoute);
            Get.snackbar("Something went wrong",
                "Perceptron was not created, please try to load data again",
                duration: const Duration(seconds: 6));
            return;
          }

          //check if inputs length is correct
          int inputsNumber = data.length - 1;
          if (inputsNumber != _perceptron.value!.inputsNumber) {
            cancel();
            Get.offAllNamed(routeController.getMainRoute);
            Get.snackbar("Wrong file template in line nr $i",
                "line input size ($inputsNumber) do not match perceptron input size (${_perceptron
                    .value!.inputsNumber})",
                duration: const Duration(seconds: 6));
            return;
          }

          //get input/output data
          String output = data[data.length - 1];
          List<String> input = data.getRange(0, data.length - 1).toList();

          //check if inputs are numbers
          for (String variable in input) {
            double? result;
            try {
              result = double.tryParse(variable);
            } catch (e) {
              result = null;
            }
            if (result == null) {
              cancel();
              Get.offAllNamed(routeController.getMainRoute);
              Get.snackbar("Wrong file template in line nr $i",
                  "$input do not match file template, to check what the data file should look like, click the link at the bottom",
                  duration: const Duration(seconds: 6));
              return;
            }
          }

          outputData.add(output);
          inputData.add(input.map((source) => double.parse(source)).toList());
        }

        //increment line number
        i++;

        //delay for visual effect
        await Future.delayed(_isFastLoading.value ? Duration.zero : duration15);
      });
      // cancel listener
      listener.cancel();

      // return if aborted loading data
      if (signal == "abort") {
        cancel();
        return;
      }

      //everything goes well :)
      _isDataLoaded.value = true;
      _isDataLoading.value = false;
      _dataLoadingController.add("done");
      allOutputData = outputData;
      allInputData = inputData;

      debugPrint(
          "input [${allInputData
              .length}]: $allInputData\noutput [${allOutputData
              .length}]: $allOutputData");
    } catch (e) {
      cancel();
      Get.offAllNamed(routeController.getMainRoute);
      Get.snackbar("Something went wrong", "error: $e",
          duration: const Duration(seconds: 6));
      return;
    }
  }

  //data sets randomize
  void clearSets() {
    _trainingInputData.value = [];
    _trainingOutputData.value = [];
    _predictInputData.value = [];
    _predictOutputData.value = [];
  }

  void randomizeSets({required int percentage}) {
    if (percentage <= 0 || percentage >= 100) {
      Get.snackbar("Data separation failed",
          "The selected percentage: $percentage% is invalid",
          duration: const Duration(seconds: 6));
      return;
    }
    int allData = allOutputData.length;
    int percentageData = allData * percentage ~/ 100;
    if (percentageData == 0) {
      Get.snackbar("Data separation failed",
          "The selected percentage from $allData data inputs is zero",
          duration: const Duration(seconds: 6));
      return;
    }

    clearSets();

    List<int> indexes = [];
    for (int i = 0; i < allData; i++) {
      indexes.add(i);
    }

    debugPrint("${indexes.length} / $allData / $percentageData $percentage%");

    final random = Random();
    Set<int> selectedNumbers = <int>{};
    while (selectedNumbers.length < percentageData) {
      selectedNumbers.add(indexes[random.nextInt(indexes.length)]);
    }

    debugPrint("${selectedNumbers.toList()}");

    for (int i = 0; i < allData; i++) {
      if (selectedNumbers.contains(i)) {
        //go to training data
        _trainingInputData.value.add(allInputData[i]);
        _trainingOutputData.value.add(allOutputData[i]);
      } else {
        //go to test data
        _predictInputData.value.add(allInputData[i]);
        _predictOutputData.value.add(allOutputData[i]);
      }
    }
  }

  //perceptron editor
  void setActivationFunction({required ActivationFunction activationFunction}) {
    if (_trainingInputData.value.isEmpty) {
      cancel();
      Get.toNamed(routeController.getMainRoute);
      Get.snackbar("Something went wrong", "Test data set is empty",
          duration: const Duration(seconds: 6));
      return;
    }
    if (_perceptron.value == null) {
      cancel();
      Get.toNamed(routeController.getMainRoute);
      Get.snackbar(
          "Something went wrong", "The perceptron has not been initialized",
          duration: const Duration(seconds: 6));
      return;
    }

    _perceptron.value!.activationFunction = activationFunction;
  }

  void setLearningRate({required double learningRate}) {
    if (_trainingInputData.value.isEmpty) {
      cancel();
      Get.toNamed(routeController.getMainRoute);
      Get.snackbar("Something went wrong", "Test data set is empty",
          duration: const Duration(seconds: 6));
      return;
    }
    if (_perceptron.value == null) {
      cancel();
      Get.toNamed(routeController.getMainRoute);
      Get.snackbar(
          "Something went wrong", "The perceptron has not been initialized",
          duration: const Duration(seconds: 6));
      return;
    }
    if (learningRate <= 0) {
      Get.snackbar(
          "Something went wrong", "The perceptron has not been initialized",
          duration: const Duration(seconds: 6));
      return;
    }
    _perceptron.value!.learningRate = learningRate;
  }

  void outputStringToDouble() {
    if (_perceptron.value == null) {
      cancel();
      Get.toNamed(routeController.getMainRoute);
      Get.snackbar(
          "Something went wrong", "The perceptron has not been initialized",
          duration: const Duration(seconds: 6));
      return;
    }
    List<String> sortedUniqueList = allOutputData.toSet().toList()
      ..sort();
    debugPrint("unique list: $sortedUniqueList");

    int length = sortedUniqueList.length;
    double min = (_perceptron.value!.activationFunction.min ?? -length)
        .toDouble();
    double max = (_perceptron.value!.activationFunction.max ?? length)
        .toDouble();
    double section = (max - min) / (length - 1);
    outputMap = {};

    for (int i = 0; i < length; i++) {
      double value = min + section * i;
      //debugPrint("[$i] ${sortedUniqueList[i]} => $value");
      outputMap.putIfAbsent(sortedUniqueList[i], () => value);
    }

    debugPrint("output map: $outputMap");

    List<double> trainingOutputData = [];
    List<double> testingOutputData = [];

    debugPrint("output list train: ");
    for(String data in _trainingOutputData.value){
      double? value = outputMap[data];
      trainingOutputData.add(value ?? 0);
      debugPrint("$data: $value");
    }

    debugPrint("output list test: ");
    for(String data in _predictOutputData.value){
      double? value = outputMap[data];
      testingOutputData.add(value ?? 0);
      debugPrint("$data: $value");
    }

    _perceptron.value!.setData(
      testingInputData: _predictInputData.value,
      testingOutputData: testingOutputData,
      trainingInputData: _trainingInputData.value,
      trainingOutputData: trainingOutputData,
    );
  }

  void goToSimulation() async {
    await Future.delayed(Duration.zero, () => outputStringToDouble());
    Get.toNamed(routeController.getPerceptronSimulationRoute);
  }

  //simulation
  void initSimulation() {
    _isSimulationPlaying.value = false;
    _isSimulationAdding.value = false;
    simulationSpeed = 1;
    if (_perceptron.value == null) return;
    _perceptron.value!.resetData();
  }

  void startSimulation() {
    if (!_isSimulationPlaying.value) {
      _isSimulationPlaying.value = true;
      perceptronSimulation();
    }
  }

  void stopSimulation() {
    _isSimulationPlaying.value = false;
  }

  void restartSimulation() {
    _isSimulationPlaying.value = false;
    simulationSpeed = 1;
    if (_perceptron.value == null) return;
    _perceptron.value!.resetData();
  }

  void trainEpoch({required int epochs}) async {
    if (_perceptron.value == null) return;
    if (_perceptron.value!.inputs.isEmpty || _perceptron.value!.output == null) return;
    _isSimulationAdding.value = true;
    for (int epoch = 0; epoch < epochs; epoch++) {
      _perceptron.value!.trainEpoch();
      update();
      if (epochs > 1) {
        await Future.delayed(Duration(
            milliseconds: simulationSpeed == 0 ? 0 : mediumDelay ~/
                simulationSpeed));
      }
    }
    _isSimulationAdding.value = false;
  }

  void perceptronSimulation() async {
    debugPrint("start");
    if (_perceptron.value == null) return;
    if (!_perceptron.value!.isLearning && !_perceptron.value!.isTesting) return;
    while (true) {
      if (!_isSimulationPlaying.value) return;
      int milliseconds = simulationSpeed == 0 ? 0 : smallDelay ~/ simulationSpeed;
      await _perceptron.value!.train(delay: Duration(milliseconds: milliseconds));
    }
  }

  void updateSimulation(){
    update();
  }

}
