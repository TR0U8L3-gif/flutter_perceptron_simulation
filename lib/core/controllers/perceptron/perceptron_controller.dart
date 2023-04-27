import 'package:get/get.dart';

class PerceptronController extends GetxController{
  final Rx<bool> _isDataLoading = Rx(false);
  final Rx<bool> _isDataLoaded = Rx(false);

  get isDataLoading => _isDataLoading.value;
  get isDataLoaded => _isDataLoaded.value;

  void loadExampleData() async {
   _isDataLoading.value = true;
   await Future.delayed(const Duration(seconds: 5));
   _isDataLoaded.value = true;
   _isDataLoading.value = false;
  }

  void loadExampleDataCancel() async {
    _isDataLoading.value = false;
    _isDataLoaded.value = false;
  }
}