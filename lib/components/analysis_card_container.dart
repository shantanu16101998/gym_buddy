import 'package:flutter/material.dart';
import 'package:gym_buddy/components/analysis_card.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';

class AnalysisCardContainer extends StatefulWidget {
  final AnalysisHomepageResponse analysisHomepageResponse;
  const AnalysisCardContainer({super.key,required this.analysisHomepageResponse});

  @override
  State<AnalysisCardContainer> createState() => _AnalysisCardContainerState();
}

class _AnalysisCardContainerState extends State<AnalysisCardContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText.bodyHeading(text: "Current Month"),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.earnings.toString(),
                    label: "Earnings",
                    icon: Icons.credit_card),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.numberOfPeople.toString(),
                    label: "People",
                    icon: Icons.person),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.averageMonth,
                    label: "Average",
                    icon: Icons.lock_clock),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.genderRatio,
                    label: "Gender",
                    icon: Icons.transgender),
              ),
            ],
          ),
        )
      ],
    );
  }
}
