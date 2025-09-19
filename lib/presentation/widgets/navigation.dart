import 'package:flutter/material.dart';
import '../../../core/custom_assets/assets.gen.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// Main White Rounded Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// Home Button
                  GestureDetector(
                    onTap: () => onTap(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 0
                              ? Assets.images.homeactive.path
                              : Assets.images.homeinactive.path,
                          width: 34,
                          height: 44,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 56), // center button er space

                  /// Sidekick Button
                  GestureDetector(
                    onTap: () => onTap(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 2
                              ? Assets.images.sidekicknavactive.path
                              : Assets.images.sidekickinactive.path,
                          width: 62,
                          height: 44,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Center Camera Button
          Positioned(
            bottom: 19.85,
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  currentIndex == 1
                      ? Assets.images.cameranavactive.path
                      : Assets.images.cameranavinactive.path,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
