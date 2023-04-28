import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:perceptron_simulation/tools/utils/constants.dart';

class PerceptronController extends GetxController {
  final Rx<bool> _isDataLoading = Rx(false);
  final Rx<bool> _isDataLoaded = Rx(false);
  final Rx<String> _loadingDataLine = Rx("...");
  final _dataLoadingController = StreamController<String>.broadcast();

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
      }

      //other lines are perceptron learning data
      else {
        //TODO: all -> model of Perceptron and Nodes
        String output = data[data.length - 1];
        List<String> input = data.getRange(0, data.length - 1).toList();
        debugPrint("$i: $input -> $output");
      }

      //increment line number
      i++;

      //delay for visual effect
      await Future.delayed(duration50);
    });
    // cancel listener
    listener.cancel();

    // return if aborted loading data
    if (signal == "abort") return;

    //everything goes well :)
    _isDataLoaded.value = true;
    _isDataLoading.value = false;
    _dataLoadingController.add("done");
  }

  void loadDataCancel() async {
    if (_isDataLoading.value) {
      debugPrint("abort loading example file");
      _dataLoadingController.add("abort");
    }
    _loadingDataLine.value = "...";
    _isDataLoading.value = false;
    _isDataLoaded.value = false;
  }
}
