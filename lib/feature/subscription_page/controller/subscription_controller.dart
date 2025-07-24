import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  // Observable variables for toggle switches
  final RxBool isRealEstateSelected = false.obs;
  final RxBool isCarSelected = false.obs;
  
  // Computed variable to check if any option is selected
  final anyOptionSelected = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Setup listeners for the toggle switches
    ever(isRealEstateSelected, (_) => _updateSelectionStatus());
    ever(isCarSelected, (_) => _updateSelectionStatus());
  }
  
  // Toggle the Real Estate option
  void toggleRealEstate(bool value) {
    isRealEstateSelected.value = value;
  }
  
  // Toggle the Car option
  void toggleCar(bool value) {
    isCarSelected.value = value;
  }
  
  // Update the combined selection status
  void _updateSelectionStatus() {
    anyOptionSelected.value = isRealEstateSelected.value || isCarSelected.value;
  }
}