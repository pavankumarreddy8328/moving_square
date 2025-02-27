import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SquareController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  RxDouble screenWidth = 0.0.obs;
  double squareSize = 50.0;
  RxDouble targetPosition = 0.0.obs;
  RxBool isAnimating = false.obs;
  //To handle the case when screen width change when square is on the centre.
  RxBool isCentre = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(
            begin: MediaQuery.of(Get.context!).size.width / 2,
            end: MediaQuery.of(Get.context!).size.width / 2)
        .animate(controller);
    //Assigning true when it first initialized.
    isCentre.value = true;
    controller.addListener(() {
      update();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        isAnimating.value = false;
      } else {
        isAnimating.value = true;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateScreenWidth();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    controller.dispose();
    super.onClose();
  }

  void updateScreenWidth() {
    screenWidth.value = MediaQuery.of(Get.context!).size.width;
    targetPosition.value = (screenWidth - squareSize) / 2; // Start in center
    animation =
        Tween<double>(begin: targetPosition.value, end: targetPosition.value)
            .animate(controller);
  }

  void moveSquare(bool moveRight) {
    //Making it false so it wont come to centre anymore.
    isCentre.value = false;
    if (isAnimating.value) return;

    isAnimating.value = true;
    screenWidth.value = MediaQuery.of(Get.context!).size.width;
    double newPosition = moveRight ? (screenWidth.value - squareSize) : 0;
    animation = Tween<double>(begin: targetPosition.value, end: newPosition)
        .animate(controller);
    controller.forward(from: 0);
    targetPosition.value = newPosition;
  }

  void animateSquare(BoxConstraints constraints) {
    screenWidth.value = constraints.maxWidth;
    if (isCentre.value) {
      animateToCentre();
    } else {
      animateToEdge();
    }
  }

  void animateToCentre() {
    double newPosition = (screenWidth.value - squareSize) / 2;

    animation =
        Tween<double>(begin: newPosition, end: newPosition).animate(controller);
    targetPosition.value = newPosition;
  }

  void animateToEdge() {
    if (targetPosition.value != 0.0) {
      double newPosition = screenWidth.value - squareSize;

      animation = Tween<double>(begin: newPosition, end: newPosition)
          .animate(controller);
      targetPosition.value = newPosition;
    }
  }
}
