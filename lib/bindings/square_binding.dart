import 'package:get/get.dart';
import 'package:moving_square/controllers/square_controller.dart';

class SquareBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SquareController());
  }
}
