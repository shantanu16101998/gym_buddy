import 'package:flutter/material.dart';
import 'package:gym_buddy/components/analysis_card_container.dart';
import 'package:gym_buddy/components/app_scaffold.dart';

class AnalysisHomepage extends StatefulWidget {
  const AnalysisHomepage({super.key});

  @override
  State<AnalysisHomepage> createState() => _AnalysisHomepageState();
}

class _AnalysisHomepageState extends State<AnalysisHomepage> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: AnalysisCardContainer(),
    );
  }
}
