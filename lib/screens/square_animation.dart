import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moving_square/controllers/square_controller.dart';

class SquareAnimation extends GetView<SquareController> {
  const SquareAnimation({super.key});
  static const routeName = "/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Square"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          controller.animateSquare(constraints);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: controller.screenWidth.value,
                height: controller.squareSize,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: controller.controller,
                      builder: (context, child) {
                        return Positioned(
                          left: controller.animation.value,
                          child: Container(
                            width: controller.squareSize,
                            height: controller.squareSize,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return ElevatedButton(
                      onPressed: (controller.isAnimating.value ||
                              controller.targetPosition.value ==
                                  controller.screenWidth.value -
                                      controller.squareSize)
                          ? null
                          : () => controller.moveSquare(true),
                      child: const Text("Right"),
                    );
                  }),
                  const SizedBox(width: 8),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: (controller.isAnimating.value ||
                              controller.targetPosition.value == 0.0)
                          ? null
                          : () => controller.moveSquare(false),
                      child: const Text("Left"),
                    );
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
