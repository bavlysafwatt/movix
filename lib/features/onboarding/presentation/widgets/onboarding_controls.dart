import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/widgets/app_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
    super.key,
    required this.controller,
    required this.totalPages,
    required this.buttonText,
    required this.onNextPressed,
    required this.isLoading,
  });

  final PageController controller;
  final int totalPages;
  final String buttonText;
  final VoidCallback onNextPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveSpacing(context, 24),
      ),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: controller,
            count: totalPages,
            effect: ExpandingDotsEffect(
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.outlineVariant,
              dotHeight: responsiveSize(context, 8, min: 7, max: 9),
              dotWidth: responsiveSize(context, 8, min: 7, max: 9),
              spacing: responsiveSpacing(context, 8),
            ),
          ),
          verticalSpace(responsiveSpacing(context, 28)),
          AppButton(
            text: buttonText,
            onPressed: isLoading ? null : onNextPressed,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
