import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movix/core/helpers/spacing.dart';

import '../models/onboarding_content.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.content});

  final OnboardingContent content;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imageHeight = responsiveSize(
      context,
      MediaQuery.sizeOf(context).height * 0.25,
      min: 190,
      max: 300,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveSpacing(context, 24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            content.assetPath,
            height: imageHeight,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          verticalSpace(responsiveSpacing(context, 40)),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontSize: responsiveFontSize(context, 25),
              fontWeight: FontWeight.w800,
            ),
          ),
          verticalSpace(responsiveSpacing(context, 16)),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: responsiveFontSize(context, 16),
              height: 1.55,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
