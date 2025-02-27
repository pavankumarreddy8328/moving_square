import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moving_square/bindings/square_binding.dart';
import 'package:moving_square/screens/square_animation.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = [
   
    GetPage(
        name: SquareAnimation.routeName,
        page: () => SquareAnimation(),
        binding: SquareBinding(),
        transition: Transition.circularReveal,
        curve: Curves.easeInCubic,
        transitionDuration: Duration(seconds: 1)),
  ];
}