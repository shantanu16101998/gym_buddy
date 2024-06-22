import 'package:flutter/material.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shimmer/shimmer.dart';

class ScreenShimmer extends StatefulWidget {
  const ScreenShimmer({super.key});

  @override
  State<ScreenShimmer> createState() => _ScreenShimmerState();
}

class _ScreenShimmerState extends State<ScreenShimmer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: getEffectiveScreenHeight(context),
        child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 255, 255, 255),
          highlightColor: const Color.fromARGB(255, 227, 227, 226),
          child: Container(
            height: 20,
            width: 100,
            color: Colors.white,
          ),
        ));
  }
}
